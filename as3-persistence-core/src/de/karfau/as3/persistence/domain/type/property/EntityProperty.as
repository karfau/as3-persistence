/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 22:44
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.TypeRegister;

	import org.spicefactory.lib.reflect.Property;

	public class EntityProperty extends AbstractProperty {

		public function EntityProperty(clazz:Class, typeRegister:TypeRegister) {
			super(clazz, typeRegister);
		}

		override public function fromReflectionSource(source:Property):void {
			super.fromReflectionSource(source);
		}

	}
}
