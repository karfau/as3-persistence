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

	[Metadata(name="ManyToMany",types="property")]
	public class MetaTagManyToMany extends MetaTagRelationBase {

		public static const NAME:String = "ManyToMany";

		override protected function get name():String {
			return NAME;
		}

		override public function validateCardinality(reflectionSource:Property):void {
			if (!TypeUtil.isCollectionType(reflectionSource.type.getClass())) {
				throw new SyntaxError("Expected a collection-type but found " + toString(reflectionSource) + " with type " + reflectionSource.type.getClass())
			}
		}

		override public function createOwningSide():IMetaTagRelation {
			return new MetaTagManyToMany();
		}

		override public function createInverseSide(mappedBy:String):IMetaTagRelation {
			var result:MetaTagManyToMany = new MetaTagManyToMany();
			if (mappedBy)
				result.mappedBy = mappedBy;
			return result;
		}

		public function MetaTagManyToMany() {
			super(MetaTagManyToMany);
		}
	}
}
