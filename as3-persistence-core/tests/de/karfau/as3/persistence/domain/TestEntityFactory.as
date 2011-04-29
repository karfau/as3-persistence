/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 11:42
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.photos.Camera;
	import de.karfau.as3.persistence.domain.photos.GeoLocation;
	import de.karfau.as3.persistence.domain.photos.Motif;
	import de.karfau.as3.persistence.domain.photos.Photo;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.ClassPropertiesAnalysis;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.NumericIdentifier;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.*;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import org.hamcrest.text.containsString;

	use namespace meta;

	//[RunWith("spectacular.runners.SpectacularRunner")]
	public class TestEntityFactory {

		private var factory:EntityFactory;

		private var entity:IEntity;

		[Before]
		public function setup():void {
			assertNull("factory is null", factory);
			factory = new EntityFactory();

			assertNull("entity is null", entity);
		}

		[After]
		public function teardown():void {
			factory = null;
			entity = null;
		}

		[Test]
		public function CreatingAnEntityFromAClassWithoutMetatags():void {
			entity = factory.createEntity(Photo);
			assertThat("matches expected entity", entity, matchesExpectedEntity(Photo, Photo.SIMPLE_NAME));
			var identifier:IIdentifier = entity.identifier;
			assertThat("primaryKey was detected", identifier, matchesValidIdentifier(identifier, ClassPropertiesAnalysis.IDENTIFIER_PROPERTY_NAME));

			assertRegisteredType(Photo, Entity);
			assertThat("should not create types for primitive properties", factory.typeRegister.hasTypeFor(String), isFalse());
			assertThat("should not create types for collection properties", factory.typeRegister.hasTypeFor(Class(Vector.<Motif>)), isFalse());
			assertThat("should not create types for entity properties", factory.typeRegister.hasTypeFor(GeoLocation), isFalse());
			var property:EntityProperty = entity.getProperty("motifes");
			assertThat("'motifes' should have " + Motif + " as persistentClass", property, hasPropertyWithValue("persistentClass", Motif));

			assertThat("creating same again, returns same instance:", entity, strictlyEqualTo(factory.createEntity(Photo)));
			/*

			 entity = factory.createEntity(Camera);
			 assertThat("matches expected entity", entity, matchesExpectedEntity(Camera, Camera.SIMPLE_NAME));
			 identifier = entity.identifier;
			 assertThat("primaryKey was detected", identifier, isValidIdentifier(identifier, ClassPropertiesAnalysis.IDENTIFIER_PROPERTY_NAME));
			 properties = entity.getProperties();
			 assertThat("primary key is in properties", properties, hasItem(identifier));

			 assertRegisteredType(Camera, Entity);
			 */
		}

		[Test]
		public function CreatingAnEntityFromAPrimitiveClass():void {

			var types:Array = [Boolean,int,Number,String,uint,null,Object,XML,XMLList,Point,Array];

			const execution:Function = function():void {
				entity = factory.createEntity(type);
			};

			var type:Class;
			while (types.length > 0) {
				type = Class(types.pop());
				assertThat("It should fail to create an Entity for " + type,
									execution,
									throws(allOf(
															isA(ArgumentError),
															hasPropertyWithValue("message", containsString("'" + getQualifiedClassName(type) + "'"))
															))
									);
			}
		}

		[Test]
		public function CreatingAnEntityFromAClassWithMetatags():void {
			entity = factory.createEntity(Camera);
			assertThat("matches expected entity", entity, matchesExpectedEntity(Camera, Camera.SIMPLE_NAME));

			var identifier:IIdentifier = entity.identifier;
			assertThat("primaryKey was detected", identifier, matchesValidIdentifier(identifier, Camera.IDENTIFIER_NAME));

			var properties:Vector.<EntityProperty> = entity.getAllProperties();
			assertThat("primary key is in properties", properties, hasItem(identifier));

			var property:EntityProperty = entity.getProperty("photos");
			assertThat("'photos' should have " + Photo + " as persistentClass", property, hasPropertyWithValue("persistentClass", Photo));
		}

		//Todo: Matcher not an assertion
		private function matchesValidIdentifier(identifier:IIdentifier, expectedPropertyName:String):Matcher {
			return allOf(
									notNullValue(),
									isA(NumericIdentifier),
									hasPropertyWithValue("name", expectedPropertyName)
									);
		}

		private function assertRegisteredType(clazz:Class, verifyTypeClass:Class):void {
			assertTrue("factory.typeRegister hase type for " + clazz, factory.typeRegister.hasTypeFor(clazz));
			assertTrue("factory.typeRegister hase type for " + clazz + " that is of type " + verifyTypeClass,
								factory.typeRegister.getTypeForClass(clazz) is verifyTypeClass);
		}

		public function matchesExpectedEntity(clazz:Class, persistenceName:String):Matcher {
			return		allOf(notNullValue(),
										 instanceOf(IEntity),
										 hasPropertyWithValue("clazz", clazz),
										 hasPropertyWithValue("persistenceName", equalTo(persistenceName))
										 );
		}

	}
}
