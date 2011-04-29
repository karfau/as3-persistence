/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 28.04.11
 * Time: 09:55
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	import de.karfau.as3.persistence.domain.type.TypeUtil;

	import org.spicefactory.lib.reflect.Property;

	public class AbstractMetaTagToMany extends MetaTagRelationBase {

		public function AbstractMetaTagToMany(InverseRelation:Class) {
			super(InverseRelation);
		}

		override public function validateCardinality(reflectionSource:Property):void {
			if (!TypeUtil.isCollectionType(reflectionSource.type.getClass())) {
				throw new SyntaxError("Expected a collection-type but found " + toString(reflectionSource) + " with type " + reflectionSource.type.getClass())
			}
		}
	}
}
