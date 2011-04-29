/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 13:24
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.operation.BaseResponderOperation;
	import de.karfau.as3.persistence.operation.IInitializeOperation;
	import de.karfau.as3.persistence.sqlite.model.CreateTableGenerator;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	public class InitializeOperation extends BaseResponderOperation implements IInitializeOperation {

		public function InitializeOperation() {
		}

		public function onInitializeComplete(handler:Function):IInitializeOperation {
			addSucessHandler(handler);
			return this;
		}

		public function onInitializeFailed(handler:Function):IInitializeOperation {
			addErrorHandler(handler);
			return this;
		}

		public function fail(error:Error):void {
			super.applyResult(false, [error]);
		}

		public function createTableDefinitions(statementCache:StatementCache, metaModel:MetaModel):void {
			var visitor:CreateTableGenerator = new CreateTableGenerator(statementCache);
			visitor.iterate(metaModel);
		}
	}
}
