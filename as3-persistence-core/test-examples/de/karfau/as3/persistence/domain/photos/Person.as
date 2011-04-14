/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:23
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {

	public class Person extends Motif {

		public var allow_markers:Boolean = true;
		public var lastname:String;
		public var firstname:String;

		override public function getLabel():String {
			return lastname + "," + firstname;
		}

	}
}
