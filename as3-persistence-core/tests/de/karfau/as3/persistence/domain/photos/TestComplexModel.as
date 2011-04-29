/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 14:26
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.EntityFactory;
	import de.karfau.as3.persistence.domain.MetaModel;

	import org.flexunit.asserts.assertNull;

	public class TestComplexModel {

		private var model:MetaModel;

		[Before]
		public function setup():void {
			assertNull("metamodel", model);
			model = new MetaModel();
			var factory:EntityFactory = new EntityFactory();
			model.registerEntity(factory.createEntity(Photo));
			model.registerEntity(factory.createEntity(GeoLocation));
			model.registerEntity(factory.createEntity(Camera));
			model.registerEntity(factory.createEntity(Motif));
			model.registerEntity(factory.createEntity(Sight));
			model.registerEntity(factory.createEntity(Person));
			model.registerEntity(factory.createEntity(Photographer));
			model.detectRelations();
		}

		[Test]
		public function testRelationExistance():void {
			var p:Printer = new Printer();
			p.iterate(model);
			trace(p.all);
		}
	}
}

import de.karfau.as3.persistence.domain.model.BaseModelIterator;
import de.karfau.as3.persistence.domain.type.Entity;
import de.karfau.as3.persistence.domain.type.IEntity;
import de.karfau.as3.persistence.domain.type.property.IIdentifier;
import de.karfau.as3.persistence.domain.type.property.IProperty;

import org.spicefactory.lib.reflect.ClassInfo;

class Printer extends BaseModelIterator {

	public var all:String = "";

	override public function visitEntity(entity:IEntity):void {
		trace("ENTITY:", entity);
		if (entity.hasSuperEntity())
			trace("\tSUPERENTITY:", Entity(entity).superEntity);
		/*for each(var er:EntityRelation in entity.nonNavigabelRelations) {
		 trace("\tNonNavigableRELATION:", er.inverseEntity.clazz, "<-", er.owningProperty.relationTag.toString(propertyToString(er.owningProperty, true)));
		 }*/
		super.visitEntity(entity);
	}

	override public function visitProperty(property:IProperty):void {

		trace("\t" + (property is IIdentifier ? "Identifier" : "Property"), ":", propertyToString(property),
				 currentEntity.isPropertyInheritedFromSuperEntity(property.name) ?
				 " {{ declared by " + currentEntity.getPropertyFromDeclaringEntity(property.name).declaredBy.clazz + " }}" : ""
				 );

		if (property.relation) {
			var related:IProperty = property.getRelatedProperty();
			trace("\t\tRELATION:",
					 property.relationTag,
					 property.relation.isBidirectional() ? "<->" : property.isOwningRelation() ? "->" : "<-",
					 related ? related.relationTag.toString(propertyToString(related, true)) : property.getRelatedEntity()
					 );

		}

	}

	override public function visitIdentifier(property:IIdentifier):void {
		visitProperty(property);
	}

	private function propertyToString(prop:IProperty, prependEntity:Boolean = false):String {
		var result:String;
		with (prop)
			result = (prependEntity ? declaredBy.getSimpleName() + "." : "") + name + ":" + ClassInfo.forClass(persistentClass).simpleName + (isCollection() ? "(collection)" : "");
		return result;
		//return prop.toString();
	}

	private function trace(...rest):void {
		all += rest.join(" ") + "\n";
	}
}
