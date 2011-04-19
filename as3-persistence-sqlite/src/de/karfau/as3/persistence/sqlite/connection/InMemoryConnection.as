/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 22:06
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.connection {
	import de.karfau.as3.persistence.connection.*;

	import flash.utils.ByteArray;

	public class InMemoryConnection extends BaseSQLConnectionParams {

		public static const INITIAL_CONNECTION_REFERENCE_NAME:String = "temp";

		public static function Connection():InMemoryConnection {
			return new InMemoryConnection();
		}

		public static function Attachment(referenceName:String):InMemoryConnection {
			if (referenceName == INITIAL_CONNECTION_REFERENCE_NAME)
				throw new ArgumentError("referenceName may not be " + INITIAL_CONNECTION_REFERENCE_NAME + " because this is reserved for an in-memory-database, " +
																"which is used by the initial connection.");
			return new InMemoryConnection(referenceName);
		}

		public function InMemoryConnection(referenceName:String = INITIAL_CONNECTION_REFERENCE_NAME) {
			_referenceName = referenceName;
		}

		override public function get reference():Object {
			return null;
		}

		override public function get openMode():ConnectionMode {
			return null;
		}

		override public function get encryption():ByteArray {
			return null;
		}
	}
}
