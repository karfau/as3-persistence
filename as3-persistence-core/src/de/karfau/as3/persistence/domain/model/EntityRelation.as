/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 21.04.11
 * Time: 14:55
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model {
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;

	import flash.errors.IllegalOperationError;

	public class EntityRelation {

		private var owning:EntityProperty;

		private var inverseEntity:Entity;
		private var inverseProperty:EntityProperty;

		public function EntityRelation(property:EntityProperty) {
			owning = property;
		}

		public function setOwnedEntity(inverseEntity:Entity):void {
			applyInverse(inverseEntity);
			owning.relation = this;
			inverseEntity.attachNonNavigableRelation(this);
		}

		protected function applyInverse(entity:Entity, property:EntityProperty = null):void {
			if (this.inverseEntity != null) {
				throw new IllegalOperationError("inverseSide can not be set twice, but has already been set to " +
																				(inverseProperty == null ? entity : inverseProperty ));
			}
			this.inverseEntity = entity;
			if (property != null) {
				inverseProperty = property;
			}
		}

		public function setInverseNavigable(inverseProperty:EntityProperty):void {
			applyInverse(Entity(inverseProperty.declaredBy), inverseProperty);
			owning.relation = this;
			inverseProperty.relation = this;
		}
	}
}
