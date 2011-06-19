/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 14:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.model.BaseModelIterator;
	import de.karfau.as3.persistence.domain.model.IRelationship;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.IProperty;
	import de.karfau.as3.persistence.domain.type.property.NumericIdentifier;
	import de.karfau.as3.persistence.sqlite.statement.SQLType;

	public class ORMappingGenerator extends BaseModelIterator {

		private var ormModel:MetaModelORMDecorator;

		public function ORMappingGenerator(ormModel:MetaModelORMDecorator) {
			this.ormModel = ormModel;
		}

		//private var tablesWithDiscriminator:Dictionary = new Dictionary();

		private var currentTable:Table;

		override public function visitEntity(entity:IEntity):void {
			var qualifiedName:String = qualifiedTableName(entity);
			if (ormModel.hasTableWithName(qualifiedName)) {
				currentTable = ormModel.getTable(qualifiedName);
			} else {
				currentTable = new Table(entity.hasSuperEntity() ? entity.superRootEntity : entity);
			}
			currentTable.addContainedEntity(entity);
			if (currentTable.entity != entity && !currentTable.hasAttributeWithName(Table.DISCRIMINATOR_COLUMN)) {
				var discriminator:Column = new Column(currentTable, Table.DISCRIMINATOR_COLUMN, SQLType.TEXT);
				currentTable.setAttribute(discriminator);
			}

			super.visitEntity(entity);
			if (!ormModel.hasTableWithName(qualifiedName))
				ormModel.registerTable(currentTable);

			currentTable = null;
			currentEntity = null;
		}

		override public function visitProperty(property:IProperty):void {

			if (!currentEntity.hasSuperEntity() || !currentEntity.isPropertyInheritedFromSuperEntity(property.name)) {
				var name:String = property.name;
				var type:Class = property.rawClass;
				var column:IColumn;
				if (property.relation) {
					if (property.relation.hasNavigableManySide()) {

						var joinTableName:String = JoinTable.NAME_FROM_RELATION(property.relation);

						var joinTable:JoinTable;
						if (ormModel.hasTableWithName(joinTableName)) {
							joinTable = ormModel.getTable(joinTableName) as JoinTable;
						} else {
							joinTable = createJoinTableFromRelation(property.relation);
							ormModel.registerTable(joinTable);
						}
						currentTable.addJoinColumn(property.name, joinTable);
						return;
					} else {//property.relation has no navigable Many-side
						column = new ForeignKeyColumn(currentTable, name, property.getRelatedEntity().identifier);
					}
				} else {//property without relation
					column = new Column(currentTable, name, SQLType.forClass(type));
					if (property is NumericIdentifier) {
						column.addConstraint(Column.PRIMARY_KEY(type != Number));
						//implicit NOT NULL, UNIQUE
					} else {//property is not a Numeric identifier
						//TODO: other constraints:NOT NULL,UNIQUE,DEFAULT,COLLATE?
					}
				}
				if (column != null) {
					currentTable.setAttribute(column);
				}
			}
		}

		override public function visitIdentifier(property:IIdentifier):void {
			visitProperty(property);
		}

		private function createJoinTableFromRelation(relation:IRelationship):JoinTable {

			//TODO: persistanceUnit -> dbname
			var result:JoinTable = new JoinTable(JoinTable.NAME_FROM_RELATION(relation));

			var pk_names:Array = [];
			var column:ForeignKeyColumn = createAndAddForeignKeyColumnFromProperty(result, relation.owningProperty, true);
			pk_names.push(column.name);
			column = createAndAddForeignKeyColumnFromProperty(result, relation.owningProperty, false);
			pk_names.push(column.name);
			result.addConstraint("PRIMARY KEY (" + pk_names.join(", ") + ")");
			return result;
		}

		private function createAndAddForeignKeyColumnFromProperty(table:JoinTable, owningProperty:IProperty, inverse:Boolean):ForeignKeyColumn {
			var relevantEntity:IEntity = inverse ? owningProperty.getRelatedEntity() : owningProperty.declaredBy;

			//var relevantProperty:IProperty = inverse ? owningProperty.relation.inverseProperty : owningProperty;

			var name:String = (inverse && !owningProperty.relation.isBidirectional() ? owningProperty.name : relevantEntity.persistenceName) +
												"_" + relevantEntity.identifier.name;

			var result:ForeignKeyColumn = new ForeignKeyColumn(table, name, relevantEntity.identifier);
			if (owningProperty.relation.hasNavigableManySide() && owningProperty.relation.hasOneSide()) {
				if (inverse ? owningProperty.isCollection() : !owningProperty.isCollection()) {
					result.addConstraint(Column.UNIQUE);
				}
			}
			result.addConstraint(Column.NOT_NULL);//TODO: depends on Required
			result.addConstraint(Column.FOREIGN_KEY_CLAUSE(qualifiedTableName(relevantEntity), [relevantEntity.identifier.name]));

			table.setAttribute(result);

			return result;
		}

	}
}
