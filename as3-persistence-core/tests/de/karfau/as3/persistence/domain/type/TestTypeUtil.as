/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 22:38
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import mx.collections.ArrayCollection;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.instanceOf;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.types.Private;

	public class TestTypeUtil {

		private var test:Class;

		[Test]
		public function primitiveTypes():void {
			var _true:Array = [Boolean, int, Number, String, uint];
			var _false:Array = [Object, null, undefined];

			for each(test in _true)
				assertTrue(test, TypeUtil.isPrimitiveType(test));

			for each(test in _false)
				assertFalse("not " + test, TypeUtil.isPrimitiveType(test));

		}

		[Test]
		public function numericTypes():void {
			var _true:Array = [int, Number, uint];
			var _false:Array = [Object, Boolean, String, null, undefined];

			for each(test in _true)
				assertTrue(test, TypeUtil.isNumericType(test));

			for each(test in _false)
				assertFalse("not " + test, TypeUtil.isNumericType(test));

		}

		public static const TRUE_FOR_isCollectionType:Array =
												[
													//primitive types:
													Vector.<int>, Vector.<Number>, Vector.<uint>,//based on special type
													Vector.<Boolean>,Vector.<String>,//special: is based on Vector.<*>
													//Objects:
													Array, ArrayCollection,//untyped
													Vector.<Object>,
													Vector.<Vector.<String>>//cascading
													/*
													 Vector.<PrivateGlobal>
													 //is added in the Test, as it is not available yet
													 */
												];

		public static const FALSE_FOR_isCollectionType:Array =
												[//TODO: Enable XMLList as Collection???
													Vector, XML, XMLList, //not supported by isCollectionType :
													Boolean, int, Number, uint, String,//primitives
													Object,//complex
													null,	undefined
													/*
													 PrivateGlobal
													 //is added in the Test, as it is not available yet
													 */
												];

		[Test]
		public function collectionTypes():void {
			TRUE_FOR_isCollectionType.push(Vector.<PrivateGlobal>);
			FALSE_FOR_isCollectionType.push(PrivateGlobal);

			for each(test in TRUE_FOR_isCollectionType) {
				assertTrue(test, TypeUtil.isCollectionType(test));
			}

			for each(test in FALSE_FOR_isCollectionType) {
				assertFalse("not " + test, TypeUtil.isCollectionType(test));
			}

			var _throws:Array = [Vector.<*>];
			for (var i:int = 0; i < _throws.length; i++) {
				assertThat(_throws[i] + " throws", function():void {
					var test:Class = _throws[i];
					TypeUtil.isCollectionType(test);
				}, throws(instanceOf(Error)));

			}
		}

		public static const SUPPORTED_BY_getCollectionElementType:Array =
												[ //primitive types:
													Vector.<int>, Vector.<Number>, Vector.<uint>,//based on special type
													Vector.<Boolean>,Vector.<String>,//special: is based on Vector.<*>
													//Objects:
													Vector.<Object>,
													Vector.<Vector.<String>>//cascading
													/*
													 Vector.<PrivateGlobal>
													 //is added in the Test, as it is not available yet
													 */
												];

		public static const EXPECTED_FROM_SUPPORTED_BY_getCollectionElementType:Array =
												[ //primitive types:
													int, Number, uint, Boolean, String,
													//Objects:
													Object,Vector.<String>,//cascading
													Private //Private is spicelibs special type for unreachable Classes like PrivateGlobal
												];

		public static const UNSUPPORTED_RETURNING_NULL_FOR_getCollectionElementType:Array =
												[

													Array, ArrayCollection,	//no subtype
													Vector, XML, XMLList, //not supported by isCollectionType :
													Boolean, int, Number, uint, String,//primitives
													Object,//complex
													null,	undefined
													/*
													 PrivateGlobal
													 //is added in the Test, as it is not available yet
													 */
												];

		[Test]
		public function collectionElementTypes():void {

			SUPPORTED_BY_getCollectionElementType.push(Vector.<PrivateGlobal>);

			UNSUPPORTED_RETURNING_NULL_FOR_getCollectionElementType.push(PrivateGlobal);

			var findings:Array = [];

			var found:ClassInfo;

			for each(test in SUPPORTED_BY_getCollectionElementType) {
				found = TypeUtil.getCollectionElementType(test);
				assertNotNull(test, found);
				findings.push(found.getClass());
			}
			assertThat("found expected types", findings, array(EXPECTED_FROM_SUPPORTED_BY_getCollectionElementType));

			for each(test in UNSUPPORTED_RETURNING_NULL_FOR_getCollectionElementType) {
				found = TypeUtil.getCollectionElementType(test);
				assertNull(test, found);
			}

			var _throws:Array = [Vector.<*>];
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