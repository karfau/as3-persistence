/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 22:50
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import flash.utils.getQualifiedClassName;

	import org.spicefactory.lib.reflect.ClassInfo;

	public class TypeUtil {

		private static function IS_TYPE_IN_LIST(clazz:Class, list:Array):Boolean {
			return list.indexOf(clazz) > -1;
		}

		public static function isNumericType(clazz:Class):Boolean {
			return IS_TYPE_IN_LIST(clazz, [int,Number,uint]);
		}

		public static function isPrimitiveType(clazz:Class):Boolean {
			return IS_TYPE_IN_LIST(clazz, [Boolean,int,Number,String,uint]);
		}

		public static function isCollectionType(clazz:Class):Boolean {
			if (isPrimitiveType(clazz))
				return false;
			var ci:ClassInfo;
			trace(clazz);
			if (clazz != null) {//includes undefined: Class(undefined) -> null
				//try{
				ci = ClassInfo.forClass(clazz);
				//}catch(ref:ReferenceError){/*Vector.<*>*/}
			}
			return ci && (ci.getProperty("length") != null);
		}

		private static const REGEXPR_VECTOR_ELEMENT_TYPE:RegExp = /Vector.<([^\s]+)>$/;

		public static function getCollectionElementType(clazz:Class):Class {
			var result:Class;
			if (isCollectionType(clazz)) {
				var qfn:String = getQualifiedClassName(clazz);
				if (REGEXPR_VECTOR_ELEMENT_TYPE.test(qfn)) {
					result = ClassInfo.forName(qfn.match(REGEXPR_VECTOR_ELEMENT_TYPE).pop()).getClass();
				}
			}
			return result;
		}

		/*public static function IS_CORE_TYPE(clazz:Class):Boolean{
		 return IS_PRIMITIVE_TYPE(clazz) || IS_TYPE_IN_LIST(clazz,[Object,Array,Date,XML,XMLList]);
		 }*/
	}
}
