/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 22:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.connection {
	import de.karfau.as3.persistence.connection.ConnectionMode;

	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class FileBasedConnection extends BaseSQLConnectionParams {

		public static const DEFAULT_CONNECTION_MODE:ConnectionMode = ConnectionMode.CREATE;
		public static const INITIAL_CONNECTION_REFERENCE_NAME:String = "main";

		public static function Connection(file:File, openMode:ConnectionMode = DEFAULT_CONNECTION_MODE, encryption:ByteArray = null):FileBasedConnection {
			return new FileBasedConnection(file, openMode, encryption, INITIAL_CONNECTION_REFERENCE_NAME);
		}

		public static function Attachment(file:File, referenceName:String, openMode:ConnectionMode = DEFAULT_CONNECTION_MODE, encryption:ByteArray = null):FileBasedConnection {
			return new FileBasedConnection(file, openMode, encryption, INITIAL_CONNECTION_REFERENCE_NAME);
		}

		public function FileBasedConnection(file:File, openMode:ConnectionMode, encryption:ByteArray, referenceName:String) {
			if (file == null)
				throw new ArgumentError("Expected file-reference but was null. Use InMemoryConnection for connetion without file-reference.")
			_file = file;
			_openMode = openMode || DEFAULT_CONNECTION_MODE;
			_encryption = encryption;
			_referenceName = referenceName;
		}
	}
}
