/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 22:38
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import mx.collections.ArrayCollection;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.instanceOf;
	import org.spicefactory.lib.reflect.ClassInfo;

	public class TestTypeUtil {

		[Test]
		public function primitiveTypes():void {
			var _true:Array = [Boolean, int, Number, String, uint];
			var _false:Array = [Object, null, undefined];
			var test:Class;

			for each(test in _true)
				assertTrue(test, TypeUtil.isPrimitiveType(test));

			for each(test in _false)
				assertFalse("not " + test, TypeUtil.isPrimitiveType(test));

		}

		[Test]
		public function numericTypes():void {
			var _true:Array = [int, Number, uint];
			var _false:Array = [Object, Boolean, String, null, undefined];
			var test:Class;

			for each(test in _true)
				assertTrue(test, TypeUtil.isNumericType(test));

			for each(test in _false)
				assertFalse("not " + test, TypeUtil.isNumericType(test));

		}

		[Test]
		public function collectionTypes():void {
			var _true:Array = [Vector.<int>, Vector.<Number>, Vector.<String>, Vector.<uint>, Vector.<PrivateGlobal>,Vector.<Vector.<String>>, Array, ArrayCollection];
			var _false:Array = [Vector, XML, XMLList, Object, Boolean, String];
			var _throws:Array = [Vector.<*>,null,undefined];
			var test:Class;

			for each(test in _true) {
				assertTrue(test, TypeUtil.isCollectionType(test));
				//trace("works for "+test);
			}
			for each(test in _false)
				assertFalse("not " + test, TypeUtil.isCollectionType(test));

			for (var i:int = 0; i < _throws.length; i++) {
				assertThat(_throws[i] + " throws", function():void {
					var test:Class = _throws[i];
					TypeUtil.isCollectionType(test);
				}, throws(instanceOf(Error)));

			}
		}

		[Test]
		public function collectionElementTypes():void {
			var _true:Array = [Vector.<int>, Vector.<Number>, Vector.<String>, Vector.<uint>, Vector.<PrivateGlobal>, Vector.<Vector.<String>>];
			var _false:Array = [/* Array, ArrayCollection, */Vector, XML, XMLList, Object, Boolean, String];
			var _throws:Array = [Vector.<*>, null, undefined];
			var test:Class;
			var found:ClassInfo;

			for each(test in _true) {
				found = TypeUtil.getCollectionElementType(test);
				assertNotNull(test, found);
				trace(test + " -> " + found.getClass());
			}

			for each(test in _false) {
				found = TypeUtil.getCollectionElementType(test);
				assertNull(test, found);
			}

			for (var i:int = 0; i < _throws.length; i++) {
				assertThat(_throws[i] + " throws", function():void {
					var test:Class = _throws[i];
					found = TypeUtil.getCollectionElementType(test);
				}, throws(instanceOf(Error)));

			}
		}
	}

}
class PrivateGlobal {
}