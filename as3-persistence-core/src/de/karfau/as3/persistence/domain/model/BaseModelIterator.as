/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 14:34
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model {
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;
	import de.karfau.as3.persistence.domain.type.property.IPropertyVisitor;

	public class BaseModelIterator implements IEntityVisitor,IPropertyVisitor {

		protected var model:MetaModel;

		public function BaseModelIterator(model:MetaModel) {
			this.model = model;
			model.visitAllEntities(this);
		}

		public function visitEntity(entity:IEntity):void {
			currentEntity = entity;

			for each(var property:EntityProperty in entity.getAllProperties()) {
				property.accept(this);
			}
		}

		protected var currentEntity:IEntity;

		public function visitProperty(property:IProperty):void {
		}

		public function visitIdentifier(property:IIdentifier):void {
		}
	}
}
