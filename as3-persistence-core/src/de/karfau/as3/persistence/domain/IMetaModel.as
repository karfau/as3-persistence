/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:35
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;

	public interface IMetaModel {
		function registerEntity(entity:IEntity):void;

		function hasPersistanceName(name:String):Boolean;

		function isRegisteredEntityType(clazz:Class):Boolean;

		function getRegisteredEntityByType(clazz:Class):IEntity;

		function getRegisteredEntityTypes():Vector.<Class>;

		function visitAllEntities(visitor:IEntityVisitor):void;

		function canBeModified():Boolean;

		function detectRelations():void;
	}
}
