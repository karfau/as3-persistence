/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 15:34
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import flash.utils.describeType;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.text.containsString;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Metadata;

	public class TestMetadataTags {

		private const test:XMLList = describeType(ClassWithMetaTags)..metadata;
		private static var ci:ClassInfo;

		[BeforeClass]
		public static function setup():void {
			Metadata.registerMetadataClass(MetaTagEntity)
			Metadata.registerMetadataClass(MetaTagId)
			Metadata.registerMetadataClass(MetaTagArrayElementType)
			//Metadata.registerMetadataClass(MetaTag)
			ci = ClassInfo.forClass(ClassWithMetaTags);
		}

		[Test]
		public function LibProvidesMetatag_Entity():void {
			assertMetadataTag(MetaTagEntity);
		}

		[Test]
		public function LibProvidesMetatag_Id():void {
			assertMetadataTag(MetaTagId, "id");
		}

		[Test]
		public function LibProvidesMetatag_ArrayElementType():void {
			assertMetadataTag(MetaTagArrayElementType, "list");
		}

		/*
		 [Test]
		 public function LibProvidesMetatag_():void {
		 assertMetadataTag(MetaTag.NAME)
		 }
		 */

		private function assertMetadataTag(type:Class, propertyName:String = null):void {
			var name:String = type["NAME"];

			assertThat("Metadata [" + name + "] has not been included into the lib using the complier agrument '-keep-as3-metadata+=...'",
								test.toXMLString(), containsString('name="' + name + '"'));

			if (propertyName) {
				assertTrue("ClassInfo finds " + type + " on property '" + propertyName + "'", ci.getProperty(propertyName).hasMetadata(type));
			} else {
				assertTrue("ClassInfo finds " + type + " on class", ci.hasMetadata(type));
			}
		}

	}
}

[Entity] class ClassWithMetaTags {

	[Id]
	public var id:Number;

	[ArrayElementType("Object")]
	public var list:Array;
}
