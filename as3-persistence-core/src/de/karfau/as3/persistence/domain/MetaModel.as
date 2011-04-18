/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 19:59
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;

	import flash.utils.Dictionary;

	public class MetaModel {

		public const persistanceNames:Dictionary = new Dictionary();
		public const classes:Dictionary = new Dictionary();

		public function registerEntity(entity:IEntity):void {
			var name:String = entity.persistenceName;
			if (hasPersistanceName(name))
				throw new ArgumentError("An entity with the persistanceName '" + name + "' has already been set:" + persistanceNames[name]);
			persistanceNames[name] = entity;
			classes[entity.clazz] = entity;
		}

		public function hasPersistanceName(name:String):Boolean {
			return persistanceNames[name] is IEntity;
		}

		public function isRegisteredEntityType(clazz:Class):Boolean {
			return classes[clazz] is IEntity;
		}

		public function visitAllEntities(visitor:IEntityVisitor):void {
			for each(var entity:IEntity in persistanceNames) {
				visitor.visitEntity(entity);
			}
		}

	}
}