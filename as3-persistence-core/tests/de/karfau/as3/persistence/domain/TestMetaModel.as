/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 20:43
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.type.EntityVisitorStub;
	import de.karfau.as3.persistence.domain.type.IEntity;

	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.hamcrest.text.containsString;

	public class TestMetaModel {

		private var model:MetaModel;

		//private var factory:EntityFactory;

		[Before]
		public function setup():void {
			assertNull("model is null", model);
			model = new MetaModel();

			//assertNull("factory is null", factory);
			//factory = new EntityFactory();

		}

		[After]
		public function teardown():void {
			model = null;
			//factory = null;
		}

		[Test]
		public function AnEntityCanBeVisitedAfterRegisteringIt():void {
			var entity:IEntity = new EntityStub("stub");
			model.registerEntity(entity);
			var visitor:EntityVisitorStub = new EntityVisitorStub();
			model.visitAllEntities(visitor);
			assertThat("entity should have been visited", visitor.visited, array(entity));
		}

		[Test]
		public function ModelHasThePersistanceNameOfAnEntityAfterRegisteringIt():void {
			var entity:IEntity = new EntityStub("stub");
			model.registerEntity(entity);

			assertTrue("entity should have been visited", model.hasPersistanceName(entity.persistenceName));
		}

		[Test]
		public function ModelHasClassOfAnEntityAfterRegisteringIt():void {
			var entity:IEntity = new EntityStub("stub");
			model.registerEntity(entity);

			assertTrue("entity should have been visited", model.isRegisteredEntityType(Object));
		}

		[Test]
		public function RegisteringTheSamePersistanceNameTwiceFails():void {
			//TODO: test vs. classes, modify stub
			var first:IEntity = new EntityStub("stub");
			var second:IEntity = new EntityStub("stub");
			model.registerEntity(first);
			const execute:Function = function():void {
				model.registerEntity(second);
			}

			//mismatch-description could be very misleading, as it causes execution again
			assertThat(execute,
								throws(allOf(
														isA(ArgumentError),
														hasPropertyWithValue("message", allOf(containsString("persistanceName '" + first.persistenceName + "'"),
																																 containsString(first.toString())))
														)));
		}

		[Test]
		public function RegisteringTheSameClassTwiceFails():void {
			var first:IEntity = new EntityStub("stub1");
			var second:IEntity = new EntityStub("stub2");
			model.registerEntity(first);
			const execute:Function = function():void {
				model.registerEntity(second);
			}

			//mismatch-description could be very misleading, as it causes execution again
			assertThat(execute,
								throws(allOf(
														isA(ArgumentError),
														hasPropertyWithValue("message", allOf(containsString("class '" + first.clazz + "'"),
																																 containsString(first.toString())))
														)));
		}
	}

}

import de.karfau.as3.persistence.domain.type.Entity;
import de.karfau.as3.persistence.domain.type.IEntity;

class EntityStub extends Entity implements IEntity {

	function EntityStub(persistanceName:String = "stub") {
		super(Object);
		_persistenceName = persistanceName;
	}

}