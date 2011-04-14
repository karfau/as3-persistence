/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 21:38
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.TypeRegister;
	import de.karfau.as3.persistence.domain.type.IType;

	import org.spicefactory.lib.reflect.Property;

	public class AbstractProperty implements IProperty {

		protected var _name:String;

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		private var _clazz:Class;
		public function get clazz():Class {
			return _clazz;
		}

		private var typeRegister:TypeRegister;

		public function getType():IType {
			return typeRegister.getTypeForClass(_clazz);
		}

		public function AbstractProperty(clazz:Class, typeRegister:TypeRegister) {
			if (clazz == null || typeRegister == null) {
				throw new ArgumentError("Expected a Class and a TypeRegister as parameters but (at least one) was null.");
			}
			this._clazz = clazz;
			this.typeRegister = typeRegister;
		}

		public function fromReflectionSource(source:Property):void {
			_name = source.name;

		}
	}
}
