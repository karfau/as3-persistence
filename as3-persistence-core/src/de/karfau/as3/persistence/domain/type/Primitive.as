/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {

	public class Primitive extends AbstractType {

		public function Primitive(clazz:Class) {
			super(clazz);
		}

		override public function isPrimitive():Boolean {
			return true;
		}

		override public function isValue():Boolean {
			return true;
		}

	}
}
