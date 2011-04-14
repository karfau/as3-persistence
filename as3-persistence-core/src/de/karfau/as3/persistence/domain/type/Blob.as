/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 12:53
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	public class Blob extends AbstractType {

		public function Blob(clazz:Class) {
			super(clazz);
		}

		override public function isPrimitive():Boolean {
			return false;
		}

		override public function isValue():Boolean {
			return true;
		}
	}
}
