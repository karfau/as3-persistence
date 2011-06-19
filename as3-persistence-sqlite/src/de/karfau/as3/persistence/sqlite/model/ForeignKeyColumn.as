/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.06.11
 * Time: 17:46
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.sqlite.statement.SQLType;

	public class ForeignKeyColumn extends Column {

		private var _referencedTableName:String;

		public function ForeignKeyColumn(relation:ITable, name:String, referencedIdentifier:IIdentifier) {

			super(relation, name, SQLType.forClass(referencedIdentifier.rawClass));

			_referencedTableName = qualifiedTableName(referencedIdentifier.declaredBy);

			addConstraint(FOREIGN_KEY_CLAUSE(_referencedTableName, [referencedIdentifier.name]));
		}

		public function get referencedTableName():String {
			return _referencedTableName;
		}
	}
}
