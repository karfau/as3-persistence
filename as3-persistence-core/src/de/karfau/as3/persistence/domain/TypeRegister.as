/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 13:00
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.type.*;

	import flash.utils.Dictionary;

	public class TypeRegister {

		//TODO: lock register when everything is done, so it can not be modified?

		private const types:Dictionary = new Dictionary(true);

		public function getTypeForClass(clazz:Class):IType {
			return types[clazz] as IType;
		}

		public function registerType(type:IType, force:Boolean = false):void {
			types[type.clazz] = type;
		}

		public function hasTypeFor(clazz:Class):Boolean {
			return types[clazz] is IType;
		}

	}
}
