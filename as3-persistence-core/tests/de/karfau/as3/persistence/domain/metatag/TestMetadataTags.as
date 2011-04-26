/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 15:34
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagManyToMany;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagManyToOne;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToMany;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToOne;
	import de.karfau.as3.persistence.domain.photos.Photo;

	import flash.utils.describeType;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.text.containsString;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Metadata;

	public class TestMetadataTags {

		private const testClassWithMetaTags:XMLList = describeType(ClassWithMetaTags)..metadata;
		private static var ci:ClassInfo;

		[BeforeClass]
		public static function setup():void {
			Metadata.registerMetadataClass(MetaTagEntity);
			Metadata.registerMetadataClass(MetaTagId);
			Metadata.registerMetadataClass(MetaTagArrayElementType);

			//Relations:
			Metadata.registerMetadataClass(MetaTagOneToOne);
			Metadata.registerMetadataClass(MetaTagOneToMany);
			Metadata.registerMetadataClass(MetaTagManyToOne);
			Metadata.registerMetadataClass(MetaTagManyToMany);

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
			var meta:MetaTagArrayElementType = assertMetadataTag(MetaTagArrayElementType, "list");
			assertThat("type-property is set in MetaTag-instance", meta.type.getClass(), strictlyEqualTo(Photo));
		}

		[Test]
		public function LibProvidesMetatag_Relations():void {
			assertMetadataTag(MetaTagOneToOne, "oto");
			assertMetadataTag(MetaTagOneToMany, "otm");
			assertMetadataTag(MetaTagManyToOne, "mto");
			assertMetadataTag(MetaTagManyToMany, "mtm");
		}

		/*
		 [Test]
		 public function LibProvidesMetatag_():void {
		 assertMetadataTag(MetaTag.NAME)
		 }
		 */

		private function assertMetadataTag(type:Class, propertyName:String = null):* {
			var name:String = type["NAME"];

			assertThat("Metadata [" + name + "] has not been included into the lib using the complier agrument '-keep-as3-metadata+=...'",
								testClassWithMetaTags.toXMLString(), containsString('name="' + name + '"'));

			var result:Array;
			if (propertyName) {
				assertTrue("ClassInfo finds " + type + " on property '" + propertyName + "'", ci.getProperty(propertyName).hasMetadata(type));
				result = ci.getProperty(propertyName).getMetadata(type);
			} else {
				assertTrue("ClassInfo finds " + type + " on class", ci.hasMetadata(type));
				result = ci.getMetadata(type);
			}
			assertNotNull(result[0]);
			return result[0] as type;
		}

	}
}

[Entity] class ClassWithMetaTags {

	[Id]
	public var id:Number;

	[ArrayElementType("de.karfau.as3.persistence.domain.photos.Photo")]
	public var list:Array;

	[OneToOne]
	public var oto:Object;
	[ManyToOne]
	public var mto:Object;
	[OneToMany]
	public var otm:Array;
	[ManyToMany]
	public var mtm:Array;

}
