/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 17:04
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import de.karfau.as3.persistence.domain.TypeRegister;
	import de.karfau.as3.persistence.domain.photos.Photo;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.strictlyEqualTo;

	public class TestTypeRegister {

		private var typeRegister:TypeRegister;

		[Before]
		public function setup():void {
			assertNull("typeRegister", typeRegister);
			typeRegister = new TypeRegister();
		}

		[After]
		public function dispose():void {
			typeRegister = null;
		}

		[Test]
		public function hasTypeAfterRegistration():void {
			var entity:Entity = new Entity(Photo);
			typeRegister.registerType(entity);
			assertTrue(typeRegister.hasTypeFor(Photo));
		}

		[Test]
		public function registeringANewTypeInstanceForAnExistingClassOverridesTheOldOne():void {
			var entity1:IType = new Entity(Photo);
			var entity2:IType = new Entity(Photo);
			typeRegister.registerType(entity1);
			assertThat("should match first instance", typeRegister.getTypeForClass(Photo), strictlyEqualTo(entity1));
			typeRegister.registerType(entity2);
			assertThat("should match second instance", typeRegister.getTypeForClass(Photo), strictlyEqualTo(entity2));
		}

	}
}
