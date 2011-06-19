/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 20.04.11
 * Time: 10:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model.analysis {
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.domain.metatag.relation.IMetaTagRelation;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToMany;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToOne;
	import de.karfau.as3.persistence.domain.model.BaseModelIterator;
	import de.karfau.as3.persistence.domain.model.Relationship;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;

	public class ModelRelationsAnalysis extends BaseModelIterator {

		private var entityTypes:Vector.<Class>;

		override public function iterate(model:MetaModel):void {
			var inheritance:ModelInheritanceAnalysis = new ModelInheritanceAnalysis();
			inheritance.iterate(model);
			this.entityTypes = model.getRegisteredEntityTypes();
			return super.iterate(model);
		}

		override public function visitProperty(property:IProperty):void {

			//No RelationTag: only possible for unidirectional or if bidirectional is declared by inverse side
			//RelationTag.isInverseSide(): dont detect, we are only detecting from owning side
			if (model.isRegisteredEntityType(property.persistentClass) &&
					!currentEntity.isPropertyInheritedFromSuperEntity(property.name) &&
					(property.relationTag == null || !property.relationTag.isInverseSide())) {

				var inverseEntity:IEntity = model.getRegisteredEntityByType(property.persistentClass);
				var inverseProperties:Vector.<IProperty> = inverseEntity.getPropertiesByPersistentClass(currentEntity.clazz);
				var inverseProperty:EntityProperty;

				var relation:Relationship = new Relationship(EntityProperty(property));

				if (inverseProperties.length == 0) {//unidirectional relation
					if (property.relationTag == null) {
						//default relation if nothing is specified
						EntityProperty(property).relationTag = property.isCollection() ? new MetaTagOneToMany() : new MetaTagOneToOne();
					}
					relation.setOwnedEntity(Entity(inverseEntity));
				} else {//bidirectional mapping
					/*there is a special/common case with only ONE inverseProperty:*/
					if (inverseProperties.length == 1) {
						var suitable:Boolean = isSuitableInverseMapping(property, inverseProperties[0]);
						if (!suitable) {
							var errorMsg:String = "The only relation-mapping found for " + (property.relationTag ? property.relationTag.toString(property) : property) +
																		" was " + (inverseProperties[0].relationTag ? inverseProperties[0].relationTag.toString(inverseProperties[0]) : inverseProperties[0]) + ".\n";

							/* Only one exists and this one is not suitable means:
							 property   | mapping					 | solution
							 -----------|------------------|--------------
							 nothing    | [owning]				 | ignore/dont create Relation: has been detected or will be detected on owning side
							 [owning]   | [owning]				 | could be two unidirectional mappings? Not implemented yet.
							 nothing    | nothing    			 | Error: for Bidirectional relations 1 MetaTag is required
							 nothing or |                  |
							 [owning]   | [wrong mappedBy] | Error: Syntax, wrong attributename?
							 */
							if (property.relationTag == null && isOwningMapping(inverseProperties[0])) {
								return;
							}
							if (isOwningMapping(property) && isOwningMapping(inverseProperties[0])) {
								//relation.setOwnedEntity(Entity(inverseEntity));
								throw new Error(errorMsg + "This could be two independent unidirectional mappings, but this seems strange, " +
																"so it is not implemented yet.");
							}
							if (property.relationTag == null && inverseProperties[0].relationTag == null) {
								throw new SyntaxError(errorMsg + "Bidirectional relation requires at least one Metatag (found none).");
							}
							if (inverseProperties[0].relationTag && !currentEntity.hasPropertyWithName(inverseProperties[0].relationTag.mappedBy)) {
								throw new SyntaxError(errorMsg + "But" + currentEntity + " has no property with the name " + inverseProperties[0].relationTag.mappedBy + ".");
							}

						}
					}
					for each(var iprop:IProperty in inverseProperties) {
						if (isSuitableInverseMapping(property, iprop)) {
							if (inverseProperty != null) {
								throw new SyntaxError("When analysing " + inverseEntity + " for the relation from " + property.relationTag.toString(property) +
																			" there where at least 2 properties that would fit:\n" +
																			"\t" + inverseProperty.relationTag.toString(inverseProperty) + "\n" +
																			"\t" + iprop.relationTag.toString(iprop) + "\n" +
																			"And it was ambiguous which one to use.");
							} else {
								inverseProperty = iprop as EntityProperty;
							}
						}
					}
					if (inverseProperty == null) {
						throw new SyntaxError("Detected a possible biderectional relation when analysing " + property +
																	" but none of the detected inverse properties was suitable:\n" +
																	"\t" + inverseProperties.join("\n\t"));
					} else {
						var other:IMetaTagRelation;
						if (property.relationTag == null) {
							other = inverseProperty.relationTag.createOwningSide();
							other.validateCardinality(getReflectionProperty(property));
							EntityProperty(property).relationTag = other;
						} else if (inverseProperty.relationTag == null) {
							other = property.relationTag.createInverseSide(property.name);
							other.validateCardinality(getReflectionProperty(inverseProperty));
							EntityProperty(inverseProperty).relationTag = other;
						}
						relation.setInverseNavigable(inverseProperty);
					}
				}
			}
		}

		protected function isOwningMapping(property:IProperty):Boolean {
			return property.relationTag && !property.relationTag.isInverseSide();
		}

		private function isSuitableInverseMapping(owning:IProperty, candidate:IProperty):Boolean {
			var result:Boolean = false;
			if (owning.relationTag == null) {
				if (candidate.relationTag != null) {
					result = candidate.relationTag.isInverseSide() && candidate.relationTag.mappedBy == owning.name;
				}
			} else {
				result = !owning.relationTag.isInverseSide() && candidate.relationTag == null;
			}
			return result;
		}

		private function getReflectionProperty(from:IProperty):Property {
			return ClassInfo.forClass(from.declaredBy.clazz).getProperty(from.name);
		}

		override public function visitIdentifier(property:IIdentifier):void {
			//currently not relevant for relations
		}
	}
}
