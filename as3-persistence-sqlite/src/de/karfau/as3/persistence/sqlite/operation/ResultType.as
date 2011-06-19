/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 11:23
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import flash.errors.IllegalOperationError;

	public class ResultType {

		private static var creationAllowed:Boolean = true;

		public static const SUCCESS:ResultType = new ResultType(true);
		public static const ERROR:ResultType = new ResultType(false);

		{
			creationAllowed = false;
		}

		private var _value:Boolean;
		public function get value():Boolean {
			return _value;
		}

		public function ResultType(value:Boolean) {
			if (!creationAllowed) {
				throw new IllegalOperationError("ConnectionMode is an Enumeration, the only instances allowed exist as static constants.")
			}
			_value = value
		}
	}
}
