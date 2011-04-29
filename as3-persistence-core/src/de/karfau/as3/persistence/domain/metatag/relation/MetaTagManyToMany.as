/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 09:53
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	[Metadata(name="ManyToMany",types="property")]
	public class MetaTagManyToMany extends AbstractMetaTagToMany {

		public static const NAME:String = "ManyToMany";

		override protected function get name():String {
			return NAME;
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

		override public function hasOneSide():Boolean {
			return false;
		}

		public function MetaTagManyToMany() {
			super(MetaTagManyToMany);
		}
	}
}
