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

		//protected var priority:Array = [IType,Blob,IEntity,Entity];

		private const types:Dictionary = new Dictionary(true);

		public function getTypeForClass(clazz:Class):IType {
			return types[clazz] as IType;
		}

		public function registerType(type:IType, force:Boolean = false):void {
			/*if (!force && hasTypeFor(type.clazz)) {
			 var current:IType = getTypeForClass(type.clazz);
			 var currentClass:Class = getClassOfInstance(current);

			 //incompatibel type or currentClass has higher rank?
			 if (!(type is currentClass) && typeClassPrio(current) > typeClassPrio(type)) {
			 throw new ArgumentError("Could not replace current registered type " + current +
			 " with new value " + type + ".\n" +
			 "To replace a registered type: the class of the new value " +
			 "EITHER has to be a subclass of current values class " +
			 "OR it has to be stronger then the current values class (ranking:" + priority + " (low,...,high).");
			 }
			 }*/
			types[type.clazz] = type;
		}

		/*private function typeClassPrio(type:IType):uint {
		 var result:int = 0;
		 var Matching:Class;
		 for (var rank:int = priority.length; rank--;) {
		 Matching = Class(priority[rank]);
		 if (type is Matching) {
		 result = rank;
		 break;
		 }
		 }
		 return result;
		 }*/

		public function hasTypeFor(clazz:Class):Boolean {
			return types[clazz] is IType;
		}

		/*protected function getClassOfInstance(typeInstance:IType):Class {
		 return getDefinitionByName(getQualifiedClassName(typeInstance)) as Class;
		 }*/
	}
}
