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
	import de.karfau.as3.persistence.sqlite.model.ITable;
	import de.karfau.as3.persistence.sqlite.model.MetaModelORMDecorator;
	import de.karfau.as3.persistence.sqlite.model.ORMappingGenerator;
	import de.karfau.as3.persistence.sqlite.operations.AsyncOperationHandler;

	import flash.filesystem.File;

	import org.flexunit.asserts.assertNull;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.arrayWithSize;

	//use namespace meta;

	public class TestComplexModel {

		private var provider:SQLitePersistanceProvider;
		private var model:MetaModel;

		private var async:AsyncOperationHandler;

		[Before(async, timeout="20000")]
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

			model.detectRelations();
			async = new AsyncOperationHandler(this, 1000);
			var dbfile:File = File.desktopDirectory.resolvePath("beweis.sqlite");
			provider.connect(InMemoryConnection.Connection())
				//provider.connect(FileBasedConnection.Connection(dbfile, ConnectionMode.CREATE))
			.onConnect(async.addExpectedHandler(function assert():void {
				//trace.apply(null, rest);
				assertThat("connection is there", provider.connection.connected);
			}))
			.onConnectionFailed(async.createFailingHandler());

			/*provider.connect(InMemoryConnection.Attachment("test2"))
			 .onConnect(async.addExpectedHandler(function assert2():void {
			 //trace.apply(null, rest);
			 assertThat("connection2 is there", provider.connection.connected);
			 }))
			 .onConnectionFailed(async.createFailingHandler());*/
		}

		[Test]
		//[Ignore]
		public function testORMappingGenerator():void {
			var orm:MetaModelORMDecorator = new MetaModelORMDecorator(provider.metaModel);
			var generator:ORMappingGenerator = new ORMappingGenerator(orm);
			generator.iterate(provider.metaModel);
			var tables:Vector.<Vector.<ITable>> = orm.getTablesInExecutableOrder();
			var batches:Array = [];
			var batch:Array;
			{ //noinspection JSMismatchedCollectionQueryUpdateInspection
				var parallel:Vector.<ITable>
			}
			for each(parallel in tables) {
				batch = [];
				for each(var table:ITable in parallel) {
					batch.push(table.createDDL());
				}
				batches.push("{{\n" + batch.join(";\n") + ";\n}}");
			}
			var flat:String = batches.join("\n");

			assertThat("tables", tables, arrayWithSize(3));
		}

		[Test(async,timeout="300000")]
		[Ignore]
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












