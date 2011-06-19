/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 01.06.11
 * Time: 00:30
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.sqlite.statement.SQLType;

	public class Column implements IColumn {

		private var _relation:ITable;
		public static const NOT_NULL:String = "NOT NULL";

		public static const UNIQUE:String = "UNIQUE";

		private static const PRIMARY_KEY$:String = "PRIMARY KEY";

		public static const REFERENCES$:String = "REFERENCES ";

		public function get relation():ITable {
			return _relation;
		}

		private var _dataType:SQLType;
		public function get dataType():SQLType {
			return _dataType;
		}

		private var _name:String;

		public function get name():String {
			return _name;
		}

		private var _constraints:Vector.<String> = new Vector.<String>();

		public function addConstraint(constraint:String):void {
			_constraints.push(constraint);
		}

		public function Column(relation:ITable, name:String, dataType:SQLType) {
			this._relation = relation;
			_name = name;
			_dataType = dataType;
		}

		public function getDDLDefinition():String {
			return _name + " " + _dataType + " " + _constraints.join(" ");
		}

		public static function PRIMARY_KEY(autoincrement:Boolean):String {
			return PRIMARY_KEY$ + (autoincrement ? " AUTOINCREMENT" : "");
		}

		public static function FOREIGN_KEY_CLAUSE(foreignTableName:String, columnNames:Array):String {
			return REFERENCES$ + foreignTableName + "(" + columnNames.join(",") + ")";
		}
	}
}
