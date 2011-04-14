/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:25
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	/**
	 * This class is an example for a persistable class without any metadata.
	 *
	 */
	public class Photo {

		meta static const SIMPLE_NAME:String = "Photo";
		meta static const TYPES:Array = [String,Date,GeoLocation,Camera];

		public var id:int;

		public var histogram:Vector.<int>;
		public var titel:String;
		public var zeitpunkt:Date;
		public var aufnahmeort:GeoLocation;
		public var motives:Vector.<Motif>;
		public var aufnahmegeraet:Camera;
	}
}
