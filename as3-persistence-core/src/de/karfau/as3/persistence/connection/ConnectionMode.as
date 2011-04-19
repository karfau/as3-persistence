/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 13:25
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.connection {
	import flash.errors.IllegalOperationError;

	public class ConnectionMode {

		public static const CREATE:ConnectionMode = new ConnectionMode("create");
		public static const READ:ConnectionMode = new ConnectionMode("read");

		private static const creationAllowed:Boolean = false;

		private var _value:String;
		public function get value():String {
			return _value;
		}

		public function ConnectionMode(value:String) {
			if (!creationAllowed) {
				throw new IllegalOperationError("ConnectionMode is an Enumeration, the only instances allowed exist as static constants.")
			}
		}
	}
}
