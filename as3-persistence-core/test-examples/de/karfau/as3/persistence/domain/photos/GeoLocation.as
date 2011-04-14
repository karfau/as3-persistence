/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:17
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	[Entity("geo")]
	public class GeoLocation {

		meta static const ENTITY_NAME:String = "geo";

		[Id]
		public var id:int;

		public var height:Number;
		//public var position:Point;
		//public var region:String;
	}
}
