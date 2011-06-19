/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:53
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.sqlite.statement.SQLType;

	public interface IColumn {
		function get name():String;

		function getDDLDefinition():String;

		function get relation():ITable;

		function get dataType():SQLType;

		function addConstraint(constraint:String):void;

	}
}
