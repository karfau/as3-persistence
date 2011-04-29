/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 14:26
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite {
	import de.karfau.as3.persistence.domain.EntityFactory;
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.domain.photos.*;
	import de.karfau.as3.persistence.sqlite.connection.InMemoryConnection;
	import de.karfau.as3.persistence.sqlite.model.CreateTableGenerator;
	import de.karfau.as3.persistence.sqlite.operations.AsyncOperationHandler;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	import org.flexunit.asserts.assertNull;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.arrayWithSize;

	//use namespace meta;

	public class TestComplexModel {

		private var provider:SQLitePersistanceProvider;
		private var model:MetaModel;

		private var async:AsyncOperationHandler;

		[Before(async)]
		public function setup():void {
			async = null;

			assertNull("provider", provider);
			provider = new SQLitePersistanceProvider();
			model = provider.metaModel;
			var factory:EntityFactory = new EntityFactory();
			model.registerEntity(factory.createEntity(Photo));
			model.registerEntity(factory.createEntity(GeoLocation));
			model.registerEntity(factory.createEntity(Camera));
			model.registerEntity(factory.createEntity(Motif));
			model.registerEntity(factory.createEntity(Sight));
			model.registerEntity(factory.createEntity(Person));
			model.registerEntity(factory.createEntity(Photographer));

			//model.detectRelations();
			async = new AsyncOperationHandler(this, 200);
			provider.connect(InMemoryConnection.Connection())
			.onConnect(async.addExpectedHandler(function():void {
				//trace.apply(null, rest);
				assertThat("connection is there", provider.connection.connected);
			}))
			.onConnectionFailed(async.createFailingHandler());
		}

		[Test]
		[Ignore]
		public function testCreateTableGenerator():void {
			var stmtCache:StatementCache = new StatementCache();
			var generator:CreateTableGenerator = new CreateTableGenerator(stmtCache);
			generator.iterate(provider.metaModel);
			var statements:Vector.<Vector.<String>> = stmtCache.compileAll();
			var batches:Array = [];
			for each(var parallel:Vector.<String> in statements) {
				batches.push("{{\n" + parallel.join(";\n") + ";\n}}");
			}
			var flat:String = batches.join("\n");

			assertThat("batches", batches, arrayWithSize(3));
		}

		[Test(async,timeout="300000")]
		public function initFromModel():void {
			async = new AsyncOperationHandler(this, 300000);
			provider.initializePersistentModel()
			.onInitializeComplete(async.addExpectedHandler(function initCompleteHandler():void {
				trace("winning the price");
			}))
			.onInitializeFailed(async.createFailingHandler());

		}

	}
}












