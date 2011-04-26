/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 15:08
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import de.karfau.as3.persistence.domain.model.EntityRelation;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;

	import flash.utils.Dictionary;

	public class Entity extends AbstractType implements IEntity {

		protected var _persistenceName:String;
		public function get persistenceName():String {
			return _persistenceName;
		}

		public function set persistenceName(value:String):void {
			_persistenceName = value;
		}

		private var _identifier:IIdentifier;
		public function get identifier():IIdentifier {
			return _identifier;
		}

		public function set identifier(value:IIdentifier):void {
			_identifier = value;
			setProperty(value as EntityProperty);
		}

		public function Entity(clazz:Class) {
			super(clazz);
		}

		private var _properties:Dictionary = new Dictionary();

		public function getAllProperties(filter:Function = null):Vector.<EntityProperty> {
			var result:Vector.<EntityProperty> = new Vector.<EntityProperty>();
			for each(var prop:EntityProperty in _properties) {
				if (filter == null || filter(prop))
					result.push(prop);
			}
			return result;
		}

		public function getPropertiesByPersistentClass(persistentClass:Class):Vector.<EntityProperty> {
			return getAllProperties(function (property:EntityProperty):Boolean {
				return property.persistentClass == persistentClass
			});
		}

		public function hasPropertyWithName(name:String):Boolean {
			return _properties.hasOwnProperty(name)
		}

		public function getProperty(name:String):EntityProperty {
			return (_properties[name] as EntityProperty);
		}

		private var _nonNavigabelRelations:Vector.<EntityRelation> = new Vector.<EntityRelation>();

		public function attachNonNavigableRelation(entityRelation:EntityRelation):void {
			_nonNavigabelRelations
		}

		public function get nonNavigabelRelations():Vector.<EntityRelation> {
			return _nonNavigabelRelations.slice();
		}

		override protected function describeInstance(...rest):Object {
			return super.describeInstance(rest, {persistenceName: persistenceName});
		}

		public function setProperty(property:EntityProperty):Boolean {
			if (property.declaredBy != null) {
				throw new ArgumentError(property + " is already part declared by " + property.declaredBy);
			}
			property.declaredBy = this;
			_properties[property.name] = property;
			return true;
		}

		public function accept(visitor:IEntityVisitor):void {
			visitor.visitEntity(this);
		}
	}
}
