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

	import flash.utils.Dictionary;

	import org.hamcrest.Matcher;

	public class Entity extends AbstractType implements IEntity {

		private var _persistenceName:String;
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

		public function getProperties(filter:Matcher = null):Vector.<EntityProperty> {
			var result:Vector.<EntityProperty> = new Vector.<EntityProperty>();
			for each(var prop:EntityProperty in _properties) {
				if (filter == null || filter.matches(prop)) {
					result.push(prop);
				}

			}
			return result;
		}

		public function hasPropertyWithName(name:String):Boolean {
			return _properties.hasOwnProperty(name)
		}

		public function getProperty(name:String):EntityProperty {
			return (_properties[name] as EntityProperty);
		}

		override public function isPrimitive():Boolean {
			return false;
		}

		override public function isValue():Boolean {
			return false;
		}

		override protected function describeInstance(more:Object = null):Object {
			return super.describeInstance({persistenceName: persistenceName});
		}

		public function setProperty(property:EntityProperty):Boolean {
			if (_properties[property.name] is IIdentifier && !(property is IIdentifier)) {
				return false;
			}
			_properties[property.name] = property;
			return true;
		}
	}
}
