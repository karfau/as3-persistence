/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	public class Camera {

		meta static const SIMPLE_NAME:String = "Camera";

		public var model:String;

		public var seriennummer:String;

		public var photos:Vector.<Photo>;

		private var _id:int;

		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}
	}
}
