/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 31.05.11
 * Time: 23:41
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model {
	import de.karfau.as3.persistence.domain.IMetaModel;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;

	public class AbstractMetaModelDecorator implements IMetaModel {

		var decorated:IMetaModel;

		public function AbstractMetaModelDecorator(decorated:IMetaModel) {
			this.decorated = decorated;
		}

		public function registerEntity(entity:IEntity):void {
			decorated.registerEntity(entity);
		}

		public function hasPersistanceName(name:String):Boolean {
			return decorated.hasPersistanceName(name);
		}

		public function isRegisteredEntityType(clazz:Class):Boolean {
			return decorated.isRegisteredEntityType(clazz);
		}

		public function getRegisteredEntityByType(clazz:Class):IEntity {
			return decorated.getRegisteredEntityByType(clazz);
		}

		public function getRegisteredEntityTypes():Vector.<Class> {
			return decorated.getRegisteredEntityTypes();
		}

		public function visitAllEntities(visitor:IEntityVisitor):void {
			decorated.visitAllEntities(visitor);
		}

		public function canBeModified():Boolean {
			return decorated.canBeModified();
		}

		public function detectRelations():void {
			decorated.detectRelations();
		}
	}
}
