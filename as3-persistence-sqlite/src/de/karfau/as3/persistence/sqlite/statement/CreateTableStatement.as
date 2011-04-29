/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 14:44
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.statement {
	import flash.utils.Dictionary;

	public class CreateTableStatement {
		public static const DISCRIMINATOR_COLUMN:String = "__TYPE__";

		public static const NOT_NULL:String = "NOT NULL";

		public static const UNIQUE:String = "UNIQUE";

		private static const PRIMARY_KEY$:String = "PRIMARY KEY";

		public static function PRIMARY_KEY(autoincrement:Boolean):String {
			return PRIMARY_KEY$ + (autoincrement ? " AUTOINCREMENT" : "");
		}

		public static const REFERENCES$:String = "REFERENCES ";

		public static function FOREIGN_KEY_CLAUSE(foreignTableName:String, columnNames:Array):String {
			return REFERENCES$ + foreignTableName + "(" + columnNames.join(",") + ")";
		}

		public var dbname:String;

		public var tablename:String;

		public function get qualifiedName():String {
			return (dbname ? dbname + "." : "") + tablename;
		}

		private var _joinTableNames:Vector.<String> = new Vector.<String>();

		public function get joinTableNames():Vector.<String> {
			return _joinTableNames.slice();
		}

		public function addJoinTableName(qualifiedName:String):Boolean {
			if (_joinTableNames.indexOf(qualifiedName) == -1) {
				_joinTableNames.push(qualifiedName);
				return true;
			}
			return false;
		}

		public function CreateTableStatement(tablename:String, dbname:String = null) {
			this.dbname = dbname;
			this.tablename = tablename;
		}

		private var _columns:Dictionary = new Dictionary();

		public function get columns():Array {
			var pks:Array = [];
			var fks:Array = [];
			var result:Array = [];
			for each(var cDef:ColumnDefinition in _columns) {
				if (cDef.hasConstraint(PRIMARY_KEY$))
					pks.push(cDef);
				else if (cDef.hasConstraint(REFERENCES$))
					fks.push(cDef);
				else
					result.push(cDef);
			}
			return pks.concat(fks.sort(Array.CASEINSENSITIVE)).concat(result.sort(Array.CASEINSENSITIVE));
		}

		public function hasColumn(columnName:String):Boolean {
			return _columns[columnName] is ColumnDefinition;
		}

		public function addColumnDefinition(name:String, type:Class, constraints:Array = null):void {
			_columns[name] = new ColumnDefinition(name, type, constraints);
		}

		private var tableConstraints:Array = [];

		public function addTableConstraint(constraint:String):void {
			tableConstraints.push(constraint);
		}

		public function compile():String {
			var list:Array =
					[
						"CREATE TABLE IF NOT EXISTS ",qualifiedName," (\n\t",
						columns.concat(tableConstraints).join(",\n\t")
						,"\n)"];
			return list.join("");
		}

		private var _requiredTables:Dictionary = new Dictionary();

		public function get requiredTables():Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			for (var requirement:String in _requiredTables) {
				if (requirement != qualifiedName)
					result.push(requirement);
			}
			return result;
		}

		public function addRequiredTable(qualifiedTableName:String):void {
			_requiredTables[qualifiedTableName] = true;
		}

	}
}
//TODO: ddl-Paket und darin internal statt hier private

import de.karfau.as3.persistence.sqlite.statement.SQLType;

class ColumnDefinition {

	public var name:String;
	public var type:Class;
	public var constraints:Array;

	public function ColumnDefinition(name:String, type:Class, constraints:Array) {
		if (constraints == null)
			constraints = [];
		this.name = name;
		this.type = type;
		this.constraints = constraints;
	}

	public function toString():String {
		return [name,SQLType.forClass(type),constraints.join(" ")].join(" ");
	}

	public function hasConstraint(contained:String):Boolean {
		for each(var c:String in constraints) {
			if (c.indexOf(contained) > -1)
				return true;
		}
		return false;
	}
}