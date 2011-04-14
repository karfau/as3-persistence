/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 11:42
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.photos.Photo;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.NumericIdentifier;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.*;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.evaluate;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.object.notNullValue;

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
			assertThat("primaryKey was detected", identifier, allOf(
																														 notNullValue(),
																														 isA(NumericIdentifier),
																														 hasPropertyWithValue("name", EntityFactory.ID_PROPERTY_NAME),
																														 evaluate(identifier.getType().isPrimitive())
																														 ));
			const properties:Vector.<EntityProperty> = entity.getProperties();
			assertThat("primary key is in properties", properties, hasItem(identifier));
			assertRegisteredType(String);

		}

		private function assertRegisteredType(clazz:Class):void {
			assertTrue("factory.typeRegister hase type for " + clazz, factory.typeRegister.hasTypeFor(clazz));
		}

		[Test]
		[Ignore]
		public function CreatingAnEntityFromAClassWithMetatags():void {
			entity = factory.createEntity(EmptyEntityWithExplicitNaming);
			assertThat(entity, matchesExpectedEntity(EmptyEntityWithExplicitNaming,
																							EmptyEntityWithExplicitNaming.ENTITY_NAME));
		}

	}
}
