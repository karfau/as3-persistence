/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 20.04.11
 * Time: 10:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model.analysis {
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.domain.model.EntityRelation;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IEntityVisitor;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;
	import de.karfau.as3.persistence.domain.type.property.IPropertyVisitor;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;

	public class ModelRelationsAnalysis implements IEntityVisitor,IPropertyVisitor {

		private var model:MetaModel;

		private var entityTypes:Vector.<Class>;

		public function ModelRelationsAnalysis(model:MetaModel) {
			this.model = model;
			this.entityTypes = model.getRegisteredEntityTypes();
		}

		public function visitEntity(entity:IEntity):void {
			currentEntity = entity;
			//TODO: look for entities that are subclasses: create isA-Relation
			for each(var property:EntityProperty in entity.getAllProperties()) {
				property.accept(this);
			}
		}

		private var currentEntity:IEntity;

		public function visitProperty(property:IProperty):void {
			//No RelationTag: only possible for unidirectional or inverseSide of bidirectional
			//RelationTag.isInverseSide(): dont detect, we are only detecting from owning side
			if ((property.relationTag == null || !property.relationTag.isInverseSide()) && model.isRegisteredEntityType(property.persistentClass)) {

				var inverseEntity:IEntity = model.getRegisteredEntityType(property.persistentClass);
				var inverseProperties:Vector.<EntityProperty> = inverseEntity.getPropertiesByPersistentClass(currentEntity.clazz);
				var mapped:EntityProperty;

				var relation:EntityRelation = new EntityRelation(EntityProperty(property));
				var relationComplete:Boolean = false;

				switch (inverseProperties.length) {
					//unidirectional
					case 0:
						relation.setOwnedEntity(Entity(inverseEntity));
						break;

					//bidirectional
					case 1:
						mapped = inverseProperties[0];
						break;
					default://multiple relations, detect related property:
						for each(var iprop:EntityProperty in inverseProperties) {
							if (iprop.relationTag.isInverseSide() && iprop.relationTag.mappedBy == property.name) {
								mapped = iprop;
								break;
							}
						}
				}
				if (mapped != null) {
					if (property.relationTag == null && mapped.relationTag == null) {
						throw new SyntaxError("Biderectional relations need to declare at least the owning or the inverse side, " +
																	"but found related properties without declaration:\n" +
																	property + "vs.\n" + mapped);
					} else {
						relation.setInverseNavigable(mapped);
					}
				}
			}
		}

		private function getReflectionProperty(from:EntityProperty):Property {
			return ClassInfo.forClass(from.declaredBy.clazz).getProperty(from.name);
		}

		public function visitIdentifier(property:IIdentifier):void {

		}
	}
}
