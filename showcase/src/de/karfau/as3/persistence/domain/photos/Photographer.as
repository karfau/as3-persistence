/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:24
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	//use namespace meta;

	public class Photographer extends Person {
		public var cameras:Vector.<Camera>;
		meta static const SIMPLE_NAME:String = "Photographer";
	}
}
