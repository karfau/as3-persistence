/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:48
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.type.IEntity;

	import flash.utils.Dictionary;

	public class Table implements ITable {

		public static const DISCRIMINATOR_COLUMN:String = "__TYPE__";

		private var _entity:IEntity;

		public function get entity():IEntity {
			return _entity;
		}

		public function get name():String {
			return entity.persistenceName;
		}

		private var attributes:Dictionary = new Dictionary();

		public function setAttribute(attribute:IColumn):void {
			if (attribute is ForeignKeyColumn) {
				var fk:ForeignKeyColumn = attribute as ForeignKeyColumn;
				_dependingTables.push(fk.referencedTableName)
			}
			attributes[attribute.name] = attribute;
		}

		public function getAttribute(name:String):IColumn {
			return attributes[name] as IColumn;
		}

		public function hasAttributeWithName(columnName:String):Boolean {
			return attributes[name] is IColumn;
		}

		private var _dependingTables:Vector.<String> = new Vector.<String>();
		public function get dependingTables():Vector.<String> {
			return _dependingTables.slice();
		}

		private var containedEntities:Dictionary;

		public function addContainedEntity(entity:IEntity):void {
			if (containedEntities == null) {
				containedEntities = new Dictionary();
			}
			containedEntities[entity.persistenceName] = entity;
		}

		private var joinColumns:Dictionary;

		public function addJoinColumn(name:String, joinTable:JoinTable):void {
			if (joinColumns == null)
				joinColumns = new Dictionary();
			joinColumns[name] = joinTable;
		}

		public function Table(entity:IEntity) {
			_entity = entity;
		}

		public function createDDL():String {
			const lineDelim:String = ",\n\t";

			var columns:Vector.<String> = new Vector.<String>();
			for each(var column:IColumn in attributes) {
				columns.push(column.getDDLDefinition());
			}
			var constraints:String = _constraints ? lineDelim + _constraints.join(lineDelim) : "";
			var result:String = "CREATE TABLE IF NOT EXISTS " + name + "(\n\t" +
													columns.join(lineDelim) + constraints + "\n)";
			return result;
		}

		private var _constraints:Vector.<String>;

		public function addConstraint(constraint:String):void {
			if (!_constraints) {
				_constraints = new Vector.<String>();
			}
			_constraints.push(constraint);
		}
	}
}
