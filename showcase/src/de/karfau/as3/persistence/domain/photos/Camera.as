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
		meta static const IDENTIFIER_NAME:String = "pk";

		[Id]
		public var pk:int;

		public var model:String;

		public var serialno:String;

		[OneToMany(mappedBy="device")]
		[ArrayElementType("de.karfau.as3.persistence.domain.photos.Photo")]
		public var photos:Array;

	}
}
