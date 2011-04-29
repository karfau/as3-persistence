/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 22:59
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.connection {
	import de.karfau.as3.persistence.connection.ConnectionMode;
	import de.karfau.as3.persistence.connection.IConnectionParams;

	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class BaseSQLConnectionParams implements IConnectionParams {

		public var autoCompact:Boolean = false;
		public var pageSize:int = 1024;

		protected var _file:File;

		public function get reference():Object {
			return _file;
		}

		public function get file():File {
			return _file;
		}

		protected var _referenceName:String;

		public function get referenceName():String {
			return _referenceName;
		}

		protected var _openMode:ConnectionMode;

		public function get openMode():ConnectionMode {
			return _openMode;
		}

		public function get openMode$():String {
			return _openMode != null ? _openMode.value : ConnectionMode.CREATE.value;
		}

		protected var _encryption:ByteArray;

		public function get encryption():ByteArray {
			return _encryption;
		}
	}
}
