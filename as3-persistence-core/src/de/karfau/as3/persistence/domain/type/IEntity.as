/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 17:25
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;

	public interface IEntity extends IType {

		function get persistenceName():String;

		function hasPropertyWithName(name:String):Boolean;

		function getProperty(name:String):EntityProperty;

		function getAllProperties(filter:Function = null):Vector.<EntityProperty>;

		function getPropertiesByPersistentClass(persistentClass:Class):Vector.<EntityProperty>;

		function get identifier():IIdentifier;

		function accept(visitor:IEntityVisitor):void;
	}
}
