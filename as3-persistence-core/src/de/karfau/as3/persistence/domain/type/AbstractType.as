/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 12:37
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.util.ClassUtil;

	public class AbstractType implements IType {

		protected var _clazz:Class;

		public function AbstractType(clazz:Class) {
			_clazz = clazz;
		}

		public function getClassInfo():ClassInfo {
			return ClassInfo.forClass(_clazz);
		}

		public function get clazz():Class {
			return _clazz;
		}

		public function getSimpeName():String {
			return getClassInfo().simpleName;
		}

		public function getQualifiedName():String {
			return getClassInfo().name;
		}

		public function isPrimitive():Boolean {
			throw new IllegalOperationError("AbstractType.isPrimitive() is abstract and needs implementation in " + getQualifiedClassName(this));
		}

		public function isNumeric():Boolean {
			return isPrimitive() && TypeUtil.isNumericType(_clazz);
		}

		public function isValue():Boolean {
			throw new IllegalOperationError("AbstractType.isValue() is abstract and needs implementation in " + getQualifiedClassName(this));
		}

		public function toString():String {

			var description:Object = describeInstance();
			var info:Array = [];
			for (var key:String in description) {
				info[info.length] = key + "=" + description[key];
			}
			info.sort();
			return "[" + ClassUtil.getSimpleName(Object(this).constructor) + " for type <" + getQualifiedName() + ">: " + info.join("; ") + "]";
		}

		protected function describeInstance(...rest):Object {
			var result:Object = {primitive:isPrimitive(),entity:!isValue()};
			for each (var descr:Object in rest) {
				for (var key:String in descr)
					result[key] = descr[key];
			}
			return result;
		}
	}
}
