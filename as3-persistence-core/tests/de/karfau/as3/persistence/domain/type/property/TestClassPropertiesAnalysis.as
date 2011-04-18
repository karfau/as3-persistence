/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 12:55
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.metatag.MetaTagId;
	import de.karfau.as3.persistence.domain.metatag.MetaTagTransient;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.Matcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.spicefactory.lib.reflect.Metadata;
	import org.spicefactory.lib.reflect.Property;

	public class TestClassPropertiesAnalysis {

		[BeforeClass]
		public static function SETUP():void {
			Metadata.registerMetadataClass(MetaTagTransient);
			Metadata.registerMetadataClass(MetaTagId);
		}

		[Test]
		public function persistableProperties():void {
			var testling:ClassPropertiesAnalysis = ClassPropertiesAnalysis.forClass(PersistablePropertiesExample);
			assertFalse("should not have an identifier (property name is casesensitive)", testling.hasIdentifiers());
			assertThat("persistable properties",
								testling.persistableProperties,
								allOf(
										 hasItems(propertyWithName("ID"), propertyWithName("iD"), propertyWithName("Id")),
										 arrayWithSize(3)
										 ));

			assertThat("no readonly,writeonly or transient properties",
								testling.persistableProperties,
								not(anyOf(
												 hasItem(propertyWithName("readonly")),
												 hasItem(propertyWithName("writeonly")),
												 hasItem(propertyWithName("transient"))
												 )));
		}

		//TODO: identifiers are readble and writable

		[Test]
		public function identifierMeta():void {
			var testling:ClassPropertiesAnalysis = ClassPropertiesAnalysis.forClass(IdentifierMetaPropertiesExample);
			assertTrue("has identifiers", testling.hasIdentifiers());
			assertThat("persistable properties",
								testling.persistableProperties,
								allOf(
										 hasItems(propertyWithName("id"), propertyWithName("pk"), propertyWithName("pk2")),
										 arrayWithSize(3)
										 ));

			assertThat("if [Id] is found, only those are used as identifiers",
								testling.identifiers, allOf(
																					 not(hasItem(propertyWithName("id"))),
																					 hasItem(propertyWithName("pk")),
																					 hasItem(propertyWithName("pk2"))
																					 ));
		}

		[Test]
		public function identifierOnly():void {
			var testling:ClassPropertiesAnalysis = ClassPropertiesAnalysis.forClass(IdentifierOnlyPropertiesExample);
			assertTrue("has identifiers", testling.hasIdentifiers());

			const arrayWith_id_PropertyAsElement:Matcher = array(propertyWithName("id"));
			assertThat("persistable properties", testling.persistableProperties, arrayWith_id_PropertyAsElement);
			assertThat("if [Id] is found not found, only those are used as identifiers", testling.identifiers, arrayWith_id_PropertyAsElement);
		}

		[Test]
		public function identifierReadonly():void {
			var testling:ClassPropertiesAnalysis = ClassPropertiesAnalysis.forClass(IdentifierReadonlyPropertiesExample);
			assertFalse("should not have identifiers", testling.hasIdentifiers());
		}

		private function propertyWithName(name:String):Matcher {
			return allOf(isA(Property), hasPropertyWithValue("name", name));
		}
	}
}
