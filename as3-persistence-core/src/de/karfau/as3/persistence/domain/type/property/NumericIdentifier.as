/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 21:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.type.TypeUtil;

	import org.spicefactory.lib.reflect.Property;

	public class NumericIdentifier extends EntityProperty implements IIdentifier {

		public function NumericIdentifier(rawClass:Class) {
			super(rawClass);
			//super(...) is not allowed after throw
			if (!TypeUtil.isNumericType(rawClass))
				throw new ArgumentError("Expected a numeric class, but was " + rawClass + ".");
		}

		override public function fromReflectionSource(source:Property):void {
			super.fromReflectionSource(source);
		}

		override public function accept(visitor:IPropertyVisitor):void {
			visitor.visitIdentifier(this);
		}
	}
}
