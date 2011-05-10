/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 13:24
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import com.jeremyruppel.operations.base.Operation;
	import com.jeremyruppel.operations.core.IOperationGroup;
	import com.jeremyruppel.operations.group.OperationGroup;

	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.operation.IInitializeOperation;
	import de.karfau.as3.persistence.sqlite.model.CreateTableGenerator;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	import flash.data.SQLConnection;
	import flash.errors.IllegalOperationError;

	public class InitializeOperation extends AbstractSequenceOperation implements IInitializeOperation {

		private var connection:SQLConnection;
		private var metaModel:MetaModel;

		public function InitializeOperation(connection:SQLConnection, metaModel:MetaModel) {
			this.connection = connection;
			this.metaModel = metaModel;
			super(null, Error, synchronousInitBlock);
		}

		private function synchronousInitBlock(operation:Operation):void {
			if (connection == null || !connection.connected)
				throw new Error("The persistent model can only be initialized if all required connections are established.");
			//TODO: are all required persistenceUnits connected?

			if (metaModel.canBeModified())
				metaModel.detectRelations();

			const statementCache:StatementCache = new StatementCache();
			const visitor:CreateTableGenerator = new CreateTableGenerator(statementCache);
			visitor.iterate(metaModel);

			const statements:Vector.<Vector.<String>> = statementCache.compileAll();
			if (statements.length == 0)
				throw new IllegalOperationError("No CreateTable-statements were generated for execution.");
			else
				createAndAddNextBatch(statements);
			operation.succeed();

		}

		private function createAndAddNextBatch(statements:Vector.<Vector.<String>>):void {

			if (statements.length > 0) {
				var parallel:Vector.<String> = statements.shift();
				var group:IOperationGroup = (parallel.length == 1) ? sequence : new OperationGroup();
				for each(var stmt:String in parallel) {
					addFaillableResponderOperationTo(group, SQLStatementResponderOperation.fromStatementString(stmt, connection),
					function execution(responderOperation:SQLStatementResponderOperation):void {
						responderOperation.sqlStatement.execute(-1, responderOperation.responder);
					});
				}
				if (group !== sequence) {
					sequence.add(group);
				}

				// delay creation and adding of next batch to after current batch has completed by adding doing it to sequence.
				addFailableOpeartionTo(sequence, function delayedNextBatch(operation:Operation):void {
					createAndAddNextBatch(statements);
					operation.succeed();
				});
			} else {
				succeed();
			}
		}

		public function onInitializeComplete(handler:Function):IInitializeOperation {
			addSuccessHandler(handler);
			return this;
		}

		public function onInitializeFailed(handler:Function):IInitializeOperation {
			addFailedHandler(handler);
			return this;
		}

	}
}
