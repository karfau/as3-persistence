/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:17
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	import flash.geom.Point;

	public class GeoLocation {

		meta static const SIMPLE_NAME:String = "GeoLocation";

		private var _id:Number;

		/**
		 * access via getter and setter
		 */
		public function get id():Number {
			return _id;
		}

		public function set id(value:Number):void {
			_id = value;
		}

		public var height:Number;
		public var position:Point;
		public var region:String;
	}
}
