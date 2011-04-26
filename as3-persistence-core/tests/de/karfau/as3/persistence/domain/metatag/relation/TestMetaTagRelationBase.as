/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 12:50
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	import de.karfau.as3.persistence.containsStrings;

	import org.hamcrest.Matcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Metadata;

	public class TestMetaTagRelationBase {

		private static var ci:ClassInfo;

		[BeforeClass]
		public static function setup():void {
			Metadata.registerMetadataClass(MetaTagOneToOne);
			Metadata.registerMetadataClass(MetaTagOneToMany);
			Metadata.registerMetadataClass(MetaTagManyToOne);
			Metadata.registerMetadataClass(MetaTagManyToMany);

			ci = ClassInfo.forClass(InvalidRelationTags);
		}

		[Test]
		public function fromPropertyThrowsForMultiplePerProperty():void {
			assertThat(function ():void {
				MetaTagRelationBase.fromProperty(ci.getProperty("multiple"));
			}, assertThrown(SyntaxError,
										 ci.getProperty("multiple"), "Only one relation", "[OneToMany]", "[ManyToMany]"
										 ));
		}

		[Test]
		public function fromPropertyThrowsForToOneOnCollectionTypedProperties():void {
			assertThat(function ():void {
				MetaTagRelationBase.fromProperty(ci.getProperty("oto_collection"));
			}, assertThrown(SyntaxError,
										 ci.getProperty("oto_collection"), "single-value", Array
										 ));
			assertThat(function ():void {
				MetaTagRelationBase.fromProperty(ci.getProperty("mto_collection"));
			}, assertThrown(SyntaxError,
										 ci.getProperty("mto_collection"), "single-value", Array
										 ));

		}

		[Test]
		public function fromPropertyThrowsForToManyOnSingleValueTypedProperties():void {
			assertThat(function ():void {
				MetaTagRelationBase.fromProperty(ci.getProperty("otm_single_value"));
			}, assertThrown(SyntaxError,
										 ci.getProperty("otm_single_value"), "collection", Object
										 ));
			assertThat(function ():void {
				MetaTagRelationBase.fromProperty(ci.getProperty("mtm_single_value"));
			}, assertThrown(SyntaxError,
										 ci.getProperty("mtm_single_value"), "collection", Object
										 ));

		}

		private function assertThrown(errortype:Class, ...stringsInMessages):Matcher {
			return throws(allOf(
												 isA(errortype),
												 hasPropertyWithValue("message", containsStrings.apply(null, stringsInMessages))
												 ));
		}
	}
}
