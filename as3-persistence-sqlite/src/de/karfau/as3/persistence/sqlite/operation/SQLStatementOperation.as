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

	public class SQLStatementOperation extends BaseResponderOperation {

		public static function fromStatementString(statement:String, connection:SQLConnection):SQLStatementOperation {
			var stmt:SQLStatement = new SQLStatement();
			stmt.text = statement;
			stmt.sqlConnection = connection;
			return new SQLStatementOperation(stmt);
		}

		public var sqlStatement:SQLStatement;

		public function SQLStatementOperation(sqlStatement:SQLStatement) {
			this.sqlStatement = sqlStatement;
		}

		public function onResult(handler:Function):SQLStatementOperation {
			addSucessHandler(handler);
			return this;
		}

		public function onError(handler:Function):SQLStatementOperation {
			addErrorHandler(handler);
			return this;
		}
	}
}
