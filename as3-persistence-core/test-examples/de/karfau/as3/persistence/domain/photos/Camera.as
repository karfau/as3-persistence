/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {

	public class Camera {

		public var modell:String;

		public var seriennummer:String;
		[ArrayElementType("de.karfau.as3.persistence.domain.photos.Photo")]
		public var photos:Array;

		private var _id:int;

		[Id]
		public function get id():int {
			return _id;
		}

		public function set id(value:int):void {
			_id = value;
		}
	}
}
