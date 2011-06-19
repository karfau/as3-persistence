/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 15:08
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;

	import flash.utils.Dictionary;

	import org.spicefactory.lib.reflect.ClassInfo;

	public class Entity implements IEntity {

		protected var _clazz:Class;

		public function getClassInfo():ClassInfo {
			return ClassInfo.forClass(_clazz);
		}

		public function get clazz():Class {
			return _clazz;
		}

		public function isNumeric():Boolean {
			return TypeUtil.isNumericType(_clazz);
		}

		public function getSimpleName():String {
			return getClassInfo().simpleName;
		}

		public function getQualifiedName():String {
			return getClassInfo().name;
		}

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

		private var _properties:Dictionary = new Dictionary();

		public function getAllProperties(filter:Function = null):Vector.<IProperty> {
			var result:Vector.<IProperty> = new Vector.<IProperty>();
			for each(var prop:EntityProperty in _properties) {
				if (filter == null || filter(prop))
					result.push(prop);
			}
			return result;
		}

		public function getPropertiesByPersistentClass(persistentClass:Class):Vector.<IProperty> {
			return getAllProperties(function (property:IProperty):Boolean {
				return property.persistentClass == persistentClass;
			});
		}

		public function hasPropertyWithName(name:String):Boolean {
			return _properties.hasOwnProperty(name)
		}

		public function getProperty(name:String):IProperty {
			return (_properties[name] as EntityProperty);
		}

		public function setProperty(property:EntityProperty):Boolean {
			if (property.declaredBy != null) {
				throw new ArgumentError(property + " is already part declared by " + property.declaredBy);
			}
			property.declaredBy = this;
			_properties[property.name] = property;
			return true;
		}

		private var _superEntity:IEntity;
		public function get superEntity():IEntity {
			return _superEntity;
		}

		public function set superEntity(superEntity:IEntity):void {
			_superEntity = superEntity;
		}

		public function get superRootEntity():IEntity {
			var result:IEntity = _superEntity;
			if (result != null)
				while (result.hasSuperEntity()) {
					result = result.superEntity;
				}
			return result;
		}

		public function hasSuperEntity():Boolean {
			return _superEntity != null;
		}

		public function getPropertyFromDeclaringEntity(name:String):IProperty {
			if (hasSuperEntity()) {
				if (_superEntity.hasPropertyWithName(name))
					return _superEntity.getPropertyFromDeclaringEntity(name);
			}
			return getProperty(name);
		}

		public function isPropertyInheritedFromSuperEntity(name:String):Boolean {
			if (!hasPropertyWithName(name)) {
				throw new Error(this + " has no property with name " + name + ".")
			}
			return hasSuperEntity() && _superEntity.hasPropertyWithName(name);
		}

		public function Entity(clazz:Class) {
			_clazz = clazz;
		}

		public function accept(visitor:IEntityVisitor):void {
			visitor.visitEntity(this);
		}

		public function toString():String {

			var description:Object = {persistenceName: persistenceName/*primitive:isPrimitive(),entity:!isValue()*/};
			var info:Array = [];
			for (var key:String in description) {
				info[info.length] = key + "=" + description[key];
			}
			info.sort();
			return "[Entity for type <" + getQualifiedName() + ">: " + info.join("; ") + "]";
		}
	}
}
