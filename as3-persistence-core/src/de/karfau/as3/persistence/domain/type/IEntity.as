/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 17:25
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;

	public interface IEntity extends IType {

		function get persistenceName():String;

		function hasPropertyWithName(name:String):Boolean;

		function getProperty(name:String):IProperty;

		function getAllProperties(filter:Function = null):Vector.<IProperty>;

		function getPropertiesByPersistentClass(persistentClass:Class):Vector.<IProperty>;

		function get identifier():IIdentifier;

		function accept(visitor:IEntityVisitor):void;

		function hasSuperEntity():Boolean;

		function getPropertyFromDeclaringEntity(name:String):IProperty;

		function isPropertyInheritedFromSuperEntity(name:String):Boolean;

		function get superEntity():IEntity;

		function get superRootEntity():IEntity;
	}
}
