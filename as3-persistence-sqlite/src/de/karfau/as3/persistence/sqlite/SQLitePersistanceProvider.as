/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 23:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite {
	import de.karfau.as3.persistence.IPersistanceProvider;
	import de.karfau.as3.persistence.connection.IConnectionParams;
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.operation.IConnectionOperation;
	import de.karfau.as3.persistence.operation.IInitializeOperation;
	import de.karfau.as3.persistence.sqlite.connection.BaseSQLConnectionParams;
	import de.karfau.as3.persistence.sqlite.operation.ConnectionOperation;
	import de.karfau.as3.persistence.sqlite.operation.InitializeOperation;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	import flash.data.SQLConnection;

	public class SQLitePersistanceProvider implements IPersistanceProvider {

		private var _connection:SQLConnection;
		public function get connection():SQLConnection {
			return _connection;
		}

		public function connect(parameter:IConnectionParams):IConnectionOperation {
			if (_connection == null) {
				_connection = new SQLConnection();
			}
			var p:BaseSQLConnectionParams = parameter as BaseSQLConnectionParams;
			if (p == null) {
				throw new ArgumentError("parameter needs to be of type BaseSQLConnectionParams.");
			}
			var operation:ConnectionOperation = new ConnectionOperation();
			//operation.onConnect(function rememberConnectionParams():void{})
			if (!_connection.connected) {
				_connection.openAsync(p.reference, p.openMode.value, operation.responder, p.autoCompact, p.pageSize, p.encryption);
			} else {
				_connection.attach(p.referenceName, p.reference, operation.responder, p.encryption);
			}
			return operation;
		}

		private var _metaModel:MetaModel = new MetaModel();
		public function get metaModel():MetaModel {
			return _metaModel;
		}

		public function set metaModel(value:MetaModel):void {
			_metaModel = value;
		}

		private var statementCache:StatementCache;

		public function initializePersistentModel():IInitializeOperation {
			var operation:InitializeOperation = new InitializeOperation();
			try {
				if (connection == null || connection.connected == false)
					throw new Error("The persistent model can only be initialized if all required connections are established.");

				if (metaModel.canBeModified())
					metaModel.detectRelations();

				if (statementCache == null)
					statementCache = new StatementCache();

				operation.createTableDefinitions(statementCache, metaModel);//synchronous

				/*operation.verifyExistingTables(connection);//async
				 operation.createTablesInDatabase(connection);//async*/

			} catch(error:Error) {
				operation.fail(error);
			}

			return null;
		}
	}
}
