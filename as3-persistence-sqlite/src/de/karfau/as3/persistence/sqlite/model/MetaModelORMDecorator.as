/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:46
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.IMetaModel;
	import de.karfau.as3.persistence.domain.model.AbstractMetaModelDecorator;

	import flash.utils.Dictionary;

	public class MetaModelORMDecorator extends AbstractMetaModelDecorator {

		private const tables:Dictionary = new Dictionary();

		public function registerTable(table:Table):void {
			tables[table.name] = table;
		}

		public function MetaModelORMDecorator(decorated:IMetaModel) {
			super(decorated);
		}

		public function hasTableWithName(qualifiedName:String):Boolean {
			return tables[qualifiedName] is Table;
		}

		public function getTable(qualifiedName:String):Table {
			return tables[qualifiedName] as Table;
		}

		public function getTablesInExecutableOrder():Vector.<Vector.<ITable>> {
			var remaining:Object = {};
			var remainingCounter:uint = 0;
			var executed:Object = {};
			var result:Vector.<Vector.<ITable>> = new Vector.<Vector.<ITable>>();
			var iterationIndex:uint = 0;
			result[iterationIndex] = new Vector.<ITable>();
			for each(var table:ITable in tables) {
				if (table.dependingTables.length == 0) {
					result[iterationIndex].push(table);
					executed[table.name] = true;
				} else {
					remaining[table.name] = table.dependingTables;
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

			var ready:Vector.<String>;
			var qName:String;
			while (remainingCounter > 0) {
				ready = new Vector.<String>();
				for (qName in remaining) {
					if (removeExecuted(qName) == 0)
						ready.push(qName);
				}
				if (ready.length == 0) {
					//TODO: log warning about cyclic dependency
					/*throw new IllegalOperationError("The " + remainingCounter + " remaining statements require each other, none can be executed first.");*/
					for (qName in remaining) {
						ready.push(qName);
					}
				}

				result[++iterationIndex] = new Vector.<ITable>();
				for each(qName in ready) {
					result[iterationIndex].push(ITable(tables[qName]));
					executed[qName] = true;
					delete remaining[qName];
					remainingCounter--;
				}
			}
			return result;
		}
	}
}