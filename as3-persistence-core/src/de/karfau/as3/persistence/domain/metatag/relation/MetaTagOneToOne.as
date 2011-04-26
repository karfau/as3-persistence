/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 09:53
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	import de.karfau.as3.persistence.domain.type.TypeUtil;

	import org.spicefactory.lib.reflect.Property;

	[Metadata(name="OneToOne",types="property")]
	public class MetaTagOneToOne extends MetaTagRelationBase {

		public static const NAME:String = "OneToOne";

		override protected function get name():String {
			return NAME;
		}

		override public function validateCardinality(reflectionSource:Property):void {
			if (TypeUtil.isCollectionType(reflectionSource.type.getClass())) {
				throw new SyntaxError("Expected a single-value-type but found " + toString(reflectionSource) + " with type " + reflectionSource.type.getClass())
			}
		}

		public function MetaTagOneToOne() {
			super(MetaTagOneToOne);
		}
	}
}
