/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 19:59
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.model.analysis.ModelRelationsAnalysis;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class MetaModel {

		public const persistanceNames:Dictionary = new Dictionary();
		public const classes:Dictionary = new Dictionary();

		public function registerEntity(entity:IEntity):void {
			if (!canBeModified())
				throw new IllegalOperationError("This instance has already been analyzed for relations and can not be modified any longer.")
			var name:String = entity.persistenceName;
			if (hasPersistanceName(name))
				throw new ArgumentError("An entity with the persistanceName '" + name + "' has already been set:" + persistanceNames[name]);
			if (isRegisteredEntityType(entity.clazz))
				throw new ArgumentError("An entity with the class '" + entity.clazz + "' has already been set:" + classes[entity.clazz]);

			persistanceNames[name] = entity;
			classes[entity.clazz] = entity;
		}

		public function hasPersistanceName(name:String):Boolean {
			return persistanceNames[name] is IEntity;
		}

		public function isRegisteredEntityType(clazz:Class):Boolean {
			return classes[clazz] is IEntity;
		}

		public function getRegisteredEntityType(clazz:Class):IEntity {
			return classes[clazz] as IEntity;
		}

		public function getRegisteredEntityTypes():Vector.<Class> {
			const result:Vector.<Class> = new Vector.<Class>();
			for (var type:* in classes) {
				result.push(type as Class)
			}
			return result
		}

		public function visitAllEntities(visitor:IEntityVisitor):void {
			for each(var entity:IEntity in persistanceNames) {
				visitor.visitEntity(entity);
			}
		}

		private var relationsAnalysis:ModelRelationsAnalysis;

		public function canBeModified():Boolean {
			return relationsAnalysis == null;
		}

		public function detectRelations():void {
			if (canBeModified()) {
				relationsAnalysis = new ModelRelationsAnalysis();
				relationsAnalysis.iterate(this);
			}
		}
	}
}
