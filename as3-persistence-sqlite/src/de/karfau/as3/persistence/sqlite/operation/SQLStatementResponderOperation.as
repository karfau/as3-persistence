/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 29.04.11
 * Time: 13:52
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import de.karfau.as3.persistence.operation.BaseResponderOperation;

	import flash.data.SQLConnection;
	import flash.data.SQLStatement;

	public class SQLStatementResponderOperation extends BaseResponderOperation {

		public static function fromStatementString(statement:String, connection:SQLConnection):SQLStatementResponderOperation {
			var stmt:SQLStatement = new SQLStatement();
			stmt.text = statement;
			stmt.sqlConnection = connection;
			return new SQLStatementResponderOperation(stmt);
		}

		public var sqlStatement:SQLStatement;

		public function SQLStatementResponderOperation(sqlStatement:SQLStatement) {
			this.sqlStatement = sqlStatement;
		}

		public function onResult(handler:Function):SQLStatementResponderOperation {
			addSucessHandler(handler);
			return this;
		}

		public function onError(handler:Function):SQLStatementResponderOperation {
			addErrorHandler(handler);
			return this;
		}
	}
}
