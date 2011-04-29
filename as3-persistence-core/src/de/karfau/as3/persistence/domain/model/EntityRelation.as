/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 21.04.11
 * Time: 14:55
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model {
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;

	import flash.errors.IllegalOperationError;

	public class EntityRelation implements IRelation {

		private var _owningProperty:EntityProperty;
		public function get owningProperty():EntityProperty {
			return _owningProperty;
		}

		public function get owningEntity():IEntity {
			return _owningProperty.declaredBy;
		}

		private var _inverseEntity:Entity;

		public function get inverseEntity():Entity {
			return _inverseEntity;
		}

		private var _inverseProperty:EntityProperty;

		public function get inverseProperty():EntityProperty {
			return _inverseProperty;
		}

		public function EntityRelation(property:EntityProperty) {
			_owningProperty = property;
		}

		public function setOwnedEntity(inverseEntity:Entity):void {
			applyInverse(inverseEntity);
			_owningProperty.relation = this;
		}

		protected function applyInverse(entity:Entity, property:EntityProperty = null):void {
			if (this._inverseEntity != null) {
				throw new IllegalOperationError("inverseSide can not be set twice, but has already been set to " +
																				(_inverseProperty == null ? entity : _inverseProperty ));
			}
			this._inverseEntity = entity;
			if (property != null) {
				_inverseProperty = property;
			}
		}

		public function setInverseNavigable(inverseProperty:EntityProperty):void {
			applyInverse(Entity(inverseProperty.declaredBy), inverseProperty);
			_owningProperty.relation = this;
			inverseProperty.relation = this;
		}

		public function isBidirectional():Boolean {
			return _inverseProperty != null;
		}

		public function hasNavigableManySide():Boolean {
			return _owningProperty.isCollection() || (isBidirectional() && _inverseProperty.isCollection());
		}

		public function hasOneSide():Boolean {
			return _owningProperty.relationTag.hasOneSide();
		}
	}
}
