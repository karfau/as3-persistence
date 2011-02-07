/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 17:20
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {

	public class PersistentDomain {

		public function PersistentDomain() {
		}

		public function getRegisteredEntities():Vector.<IEntity> {
			return new Vector.<IEntity>();
		}
	}
}
