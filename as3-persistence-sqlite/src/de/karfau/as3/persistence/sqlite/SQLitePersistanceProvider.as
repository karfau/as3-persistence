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
			if (_connection == null)
				_connection = new SQLConnection();
			return _connection;
		}

		private var connectOperation:ConnectionOperation;
		private const connectedParameters:Vector.<BaseSQLConnectionParams> = new Vector.<BaseSQLConnectionParams>();

		public function connect(parameter:IConnectionParams):IConnectionOperation {

			if (connectOperation == null) {
				connectOperation = new ConnectionOperation(connection);
				connectOperation.releaseHandler = function removeAfterExecution():void {
					this.connectOperation = null;
				};
			}

			var responderOperation:IConnectionOperation = connectOperation.connectWith(parameter as BaseSQLConnectionParams);

			responderOperation.onConnect(function handleConnectFirst(...rest):void {
				connectedParameters.push(parameter);
			});
			//connectOperation.call();//is ignored if is already working on something

			return responderOperation;
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
			//TODO: what about calling it twice: should not execute everything again. should it throw an Error?
			var operation:InitializeOperation = new InitializeOperation(connection, metaModel);
			operation.call();
			return operation;
		}
	}
}
