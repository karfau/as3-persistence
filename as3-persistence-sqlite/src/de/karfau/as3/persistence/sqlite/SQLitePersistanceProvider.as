/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 23:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite {
	import de.karfau.as3.persistence.IPersistanceProvider;
	import de.karfau.as3.persistence.connection.IConnectionOperation;
	import de.karfau.as3.persistence.connection.IConnectionParams;
	import de.karfau.as3.persistence.domain.MetaModel;

	public class SQLitePersistanceProvider implements IPersistanceProvider {

		public function SQLitePersistanceProvider() {
		}

		public function connect(parameter:IConnectionParams):IConnectionOperation {
			return null;
		}

		public function get metaModel():MetaModel {
			return null;
		}

		public function finalizeMetaModel():Boolean {
			return false;
		}
	}
}
