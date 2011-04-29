/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 14:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.statement {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class StatementCache {

		public function StatementCache() {
		}

		private var tables:Dictionary = new Dictionary();

		public function register(stmt:CreateTableStatement):void {
			tables[stmt.qualifiedName] = stmt;
		}

		public function hasStatementForQualifiedName(qualifiedName:String):Boolean {
			return tables[qualifiedName] is CreateTableStatement;
		}

		public function getStatementByQualifiedName(qualifiedName:String):CreateTableStatement {
			return tables[qualifiedName] as CreateTableStatement;
		}

		public function compile(qualifiedName:String):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			var stmt:CreateTableStatement = getStatementByQualifiedName(qualifiedName);
			if (stmt) {
				compileSingle(stmt, result);
				for each (var jtn:String in stmt.joinTableNames) {
					result = result.concat(compile(jtn));
				}
			}
			return result;
		}

		private function compileSingle(stmt:CreateTableStatement, result:Vector.<String>):void {
			result.push(stmt.compile());
		}

		public function compileAll():Vector.<Vector.<String>> {

			var stmts:Vector.<Vector.<CreateTableStatement>> = executionOrder();
			//noinspection JSMismatchedCollectionQueryUpdateInspection
			var parallel:Vector.<CreateTableStatement>;

			var result:Vector.<Vector.<String>> = new Vector.<Vector.<String>>;
			var presult:Vector.<String>;

			for each(parallel in stmts) {
				presult = new Vector.<String>();
				for each(var stmt:CreateTableStatement in parallel) {
					compileSingle(stmt, presult);
				}
				result.push(presult)
			}
			return result;
		}

		private function executionOrder():Vector.<Vector.<CreateTableStatement>> {
			var remaining:Object = {};
			var remainingCounter:uint = 0;
			var executed:Object = {};
			var result:Vector.<Vector.<CreateTableStatement>> = new Vector.<Vector.<CreateTableStatement>>();
			var iterationIndex:uint = 0;
			result[iterationIndex] = new Vector.<CreateTableStatement>();
			for each(var stmt:CreateTableStatement in tables) {
				if (stmt.requiredTables.length == 0) {
					result[iterationIndex].push(stmt);
					executed[stmt.qualifiedName] = true;
				} else {
					remaining[stmt.qualifiedName] = stmt.requiredTables;
					remainingCounter++;
				}
			}

			function removeExecuted(qName:String):uint {
				var list:Vector.<String> = remaining[qName] as Vector.<String>;
				if (list) {
					if (list.length == 0)
						return 0;
					if (result[iterationIndex].length == 0)
						return list.length;
					list = list.filter(function(req:String, ...rest):Boolean {
						return !(executed[req] as Boolean);
					});
					remaining[qName] = list;
					return list.length;
				}
				throw new Error(qName + " is not remaining");
			}

			if (result[iterationIndex].length == 0)
				throw new IllegalOperationError("All statements require other ones, none can be executed first.");

			var ready:Vector.<String>;
			while (remainingCounter > 0) {
				ready = new Vector.<String>();
				for (var qName:String in remaining) {
					if (removeExecuted(qName) == 0)
						ready.push(qName);
				}
				if (ready.length == 0)
					throw new IllegalOperationError("The " + remainingCounter + " remaining statements require each other, none can be executed first.");

				result[++iterationIndex] = new Vector.<CreateTableStatement>();
				for each(qName in ready) {
					result[iterationIndex].push(CreateTableStatement(tables[qName]));
					executed[qName] = true;
					delete remaining[qName];
					remainingCounter--;
				}
			}
			return result;
		}
	}
}
