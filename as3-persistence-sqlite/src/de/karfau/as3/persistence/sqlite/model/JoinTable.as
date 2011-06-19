/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.06.11
 * Time: 17:22
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.model.IRelationship;

	public class JoinTable extends Table {

		public static function NAME_FROM_RELATION(relation:IRelationship):String {
			var result:String =
					[
						relation.owningEntity.persistenceName,
						relation.inverseEntity.persistenceName
					]/*.sort(Array.CASEINSENSITIVE)*/.join("_");
			return result;
		}

		private var _name:String;

		override public function get name():String {
			return _name;
		}

		public function JoinTable(name:String) {
			super(null);
			_name = name;
		}
	}
}
