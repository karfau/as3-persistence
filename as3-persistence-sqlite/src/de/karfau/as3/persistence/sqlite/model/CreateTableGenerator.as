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
	import de.karfau.as3.persistence.sqlite.statement.CreateTableStatement;
	import de.karfau.as3.persistence.sqlite.statement.StatementCache;

	import flash.utils.Dictionary;

	public class CreateTableGenerator extends BaseModelIterator {

		private var statementCache:StatementCache;

		public function CreateTableGenerator(statementCache:StatementCache) {
			this.statementCache = statementCache;
		}

		private var tablesWithDiscriminator:Dictionary = new Dictionary();

		private var currentStmt:CreateTableStatement;

		private function qualifiedTableName(entity:IEntity):String {
			//TODO: persistanceUnit -> dbname
			return entity.hasSuperEntity() ? entity.superRootEntity.persistenceName : entity.persistenceName;
		}

		override public function visitEntity(entity:IEntity):void {
			var qualifiedName:String = qualifiedTableName(entity);
			if (entity.hasSuperEntity()) {
				tablesWithDiscriminator[qualifiedName] = true;
			}
			if (statementCache.hasStatementForQualifiedName(qualifiedName)) {
				currentStmt = statementCache.getStatementByQualifiedName(qualifiedName)
			} else {
				currentStmt = new CreateTableStatement(qualifiedName);//TODO: persistanceUnit -> dbname
			}
			if (tablesWithDiscriminator[qualifiedName] as Boolean && !currentStmt.hasColumn(CreateTableStatement.DISCRIMINATOR_COLUMN)) {
				currentStmt.addColumnDefinition(CreateTableStatement.DISCRIMINATOR_COLUMN, String);
			}

			super.visitEntity(entity);
			//currentStmt.compile();
			if (!statementCache.hasStatementForQualifiedName(qualifiedName))
				statementCache.register(currentStmt);

			currentStmt = null;
			currentEntity = null;
		}

		override public function visitProperty(property:IProperty):void {

			if (!currentEntity.hasSuperEntity() || !currentEntity.isPropertyInheritedFromSuperEntity(property.name)) {
				var name:String = property.name;
				var type:Class = property.rawClass;
				var constraints:Array = [];
				if (property.relation) {
					if (property.relation.hasNavigableManySide()) {
						var joinTable:CreateTableStatement = JoinTableFromRelation(property.relation);
						currentStmt.addJoinTableName(joinTable.qualifiedName);
						statementCache.register(joinTable);
						return;
					} else {//property.relation has no navigable Many-side -> Foreign Key Column
						const relatedEntity:IEntity = property.getRelatedEntity();
						type = relatedEntity.identifier.rawClass;
						constraints.push(CreateTableStatement.FOREIGN_KEY_CLAUSE(qualifiedTableName(relatedEntity), [relatedEntity.identifier.name]));
						currentStmt.addRequiredTable(qualifiedTableName(relatedEntity));
					}
				} else {//property without relation
					//name and type are already set correct, find constraints
					if (property is NumericIdentifier) {
						constraints.push(CreateTableStatement.PRIMARY_KEY(type != Number));
						//implicit NOT NULL, UNIQUE
					} else {//property is not a Numeric identifier
						//TODO: other constraints:NOT NULL,UNIQUE,DEFAULT,COLLATE?
					}
				}
				currentStmt.addColumnDefinition(name, type, constraints);
			}
		}

		override public function visitIdentifier(property:IIdentifier):void {
			visitProperty(property);
		}

		private function JoinTableFromRelation(relation:IRelationship):CreateTableStatement {
			var name:String =
					[
						relation.owningEntity.persistenceName,
						relation.inverseEntity.persistenceName
					]/*.sort(Array.CASEINSENSITIVE)*/.join("_");

			//TODO: persistanceUnit -> dbname
			var stmt:CreateTableStatement = new CreateTableStatement(name);

			var pk_names:Array =
					[
						addForeignKeyFromProperty(stmt, relation.owningProperty, false),
						addForeignKeyFromProperty(stmt, relation.owningProperty, true)
					];
			stmt.addTableConstraint("PRIMARY KEY (" + pk_names.join(", ") + ")");

			return stmt;
		}

		private function addForeignKeyFromProperty(statement:CreateTableStatement, owningProperty:IProperty, inverse:Boolean):String {
			var re:IEntity = inverse ? owningProperty.getRelatedEntity() : owningProperty.declaredBy;

			var result:String = (inverse && !owningProperty.relation.isBidirectional() ? owningProperty.name : re.persistenceName) + "_" + re.identifier.name;

			var constraints:Array =
					[
						CreateTableStatement.NOT_NULL,//TODO: depends on Required
						CreateTableStatement.FOREIGN_KEY_CLAUSE(qualifiedTableName(re), [re.identifier.name])
					];
			if (owningProperty.relation.hasNavigableManySide() && owningProperty.relation.hasOneSide()) {
				if (inverse ? owningProperty.isCollection() : !owningProperty.isCollection())
					constraints.unshift(CreateTableStatement.UNIQUE);
			}

			statement.addRequiredTable(qualifiedTableName(re));
			statement.addColumnDefinition(result, re.identifier.rawClass, constraints);

			return result;
		}

	}
}
