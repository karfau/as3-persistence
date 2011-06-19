/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:47
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.type.IEntity;

	public interface ITable {
		function get entity():IEntity;

		function get name():String;

		function setAttribute(attribute:IColumn):void;

		function getAttribute(name:String):IColumn;

		function hasAttributeWithName(columnName:String):Boolean;

		function createDDL():String;

		function addConstraint(constraint:String):void;

		function get dependingTables():Vector.<String>;
	}
}
