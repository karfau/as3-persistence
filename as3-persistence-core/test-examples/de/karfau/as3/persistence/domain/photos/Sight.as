/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 20:14
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {

	public class Sight extends Motif {

		public var name:String;
		public var place:String;

		override public function getLabel():String {
			return name + " in " + place;
		}

	}
}
