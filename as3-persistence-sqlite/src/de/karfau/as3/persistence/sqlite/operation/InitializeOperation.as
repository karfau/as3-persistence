/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 13:24
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import com.jeremyruppel.operations.base.Operation;
	import com.jeremyruppel.operations.core.IOperation;
	import com.jeremyruppel.operations.group.OperationGroup;
	import com.jeremyruppel.operations.group.OperationQueue;

	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.operation.IInitializeOperation;
	import de.karfau.as3.persistence.sqlite.model.CreateTableGenerator;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	import flash.data.SQLConnection;
	import flash.errors.IllegalOperationError;
	import flash.errors.SQLError;

	public class InitializeOperation extends Operation implements IInitializeOperation {

		//private static var operations:Array = [];
		//private static var running:InitializeOperation;

		private var connection:SQLConnection;
		private var metaModel:MetaModel;

		private var sequence:OperationQueue = new OperationQueue();
		private var sequenceError:Error;

		public function InitializeOperation(connection:SQLConnection, metaModel:MetaModel) {
			this.connection = connection;
			this.metaModel = metaModel;
			super(null, Error, function initSequence(operation:Operation):void {
				//		running = this;
				sequence.add(synchronousInit);
				sequence.failed.add(operation.fail);//TODO:create an error for the payload;
				sequence.succeeded.add(operation.succeed);
				sequence.call();
			});
		}

		private var statements:Vector.<Vector.<String>>;

		private var synchronousInit:Operation = createSafeOperation(synchronousInitBlock);

		private function synchronousInitBlock(operation:Operation):void {
			if (connection == null || !connection.connected)
				throw new Error("The persistent model can only be initialized if all required connections are established.");
			//TODO: are all required persistenceUnits connected?

			if (metaModel.canBeModified())
				metaModel.detectRelations();

			const statementCache:StatementCache = new StatementCache();
			var visitor:CreateTableGenerator = new CreateTableGenerator(statementCache);
			visitor.iterate(metaModel);

			statements = statementCache.compileAll();
			if (statements.length == 0)
				throw new IllegalOperationError("No CreateTableSatements were created for execution.");
			else
				executeNextBatch();
			operation.succeed();

		}

		private function executeNextBatch():void {

			if (statements.length > 0) {
				var parallel:Vector.<String> = statements.shift();
				var batch:OperationGroup = new OperationGroup();
				for each(var stmt:String in parallel) {
					batch.add(executeStatement(stmt));
				}
				sequence.add(batch);
				sequence.add(createSafeOperation(function delayedNextBatch(operation:Operation):void {
					executeNextBatch();
					operation.succeed();
				}));
			} else {
				succeed();
			}
		}

		private function executeStatement(stmt:String):IOperation {
			return createSafeOperation(function executeSQL(operation:Operation):void {
				var execution:SQLStatementOperation = SQLStatementOperation.fromStatementString(stmt, connection);
				execution.onResult(operation.succeed);
				execution.onError(function handleSQLErrorEvent(error:SQLError):void {
					sequenceError = error;
					fail(sequenceError);
				});
				execution.sqlStatement.execute(-1, execution.responder);
			});
		}

		private function createSafeOperation(block:Function, ...arguments):Operation {
			return new Operation(null, Error, function safeBlock(operation:Operation):void {
				try {
					if (block.length > arguments.length)
						arguments = [operation].concat(arguments);
					block.apply(null, arguments);
					//operation.succeed();
				} catch(error:Error) {
					sequenceError = error;
					fail(error);
				}
			});
		}

		public function onInitializeComplete(handler:Function):IInitializeOperation {
			succeeded.add(handler);
			if (delaySucceed != null) {
				delaySucceed();
			}
			return this;
		}

		public function onInitializeFailed(handler:Function):IInitializeOperation {
			failed.add(handler);
			if (delayFail != null) {
				delayFail();
			}
			return this;
		}

		private var delayFail:Function;

		override public function fail(payload:* = null):void {
			if (!(payload as Boolean))
				payload = sequenceError;

			if (failed.numListeners == 0) {
				delayFail = function delay():void {
					fail(payload);
				}
			} else {
				super.fail(payload);
			}
		}

		private var delaySucceed:Function;

		override public function succeed(payload:* = null):void {
			if (succeeded.numListeners == 0) {
				delaySucceed = function delay():void {
					succeed(payload);
				}
			} else {
				super.succeed(payload);
			}
		}
	}
}
