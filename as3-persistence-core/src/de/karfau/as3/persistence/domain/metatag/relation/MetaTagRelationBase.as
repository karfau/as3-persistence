/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 10:16
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	import org.spicefactory.lib.reflect.Property;

	public class MetaTagRelationBase implements IMetaTagRelation {

		public static function fromProperty(property:Property):MetaTagRelationBase {
			var relationTags:Array = [];
			if (property.hasMetadata(MetaTagOneToMany))
				relationTags = relationTags.concat(property.getMetadata(MetaTagOneToMany));
			if (property.hasMetadata(MetaTagManyToOne))
				relationTags = relationTags.concat(property.getMetadata(MetaTagManyToOne));
			if (property.hasMetadata(MetaTagManyToMany))
				relationTags = relationTags.concat(property.getMetadata(MetaTagManyToMany));
			if (property.hasMetadata(MetaTagOneToOne))
				relationTags = relationTags.concat(property.getMetadata(MetaTagOneToOne));
			var found:MetaTagRelationBase;
			switch (relationTags.length) {
				case 0://no relation to set
					return null;
				case 1:
					found = relationTags[0];
					found.validateCardinality(property);
					return found;
				default://more than one, not supported by now
					throw new SyntaxError("Only one relation-metatag (one of [" +
																[MetaTagOneToOne.NAME,MetaTagOneToMany.NAME,MetaTagManyToOne.NAME,MetaTagManyToMany.NAME].join("], [") +
																"]) is allowed per property, but " + property + " is annotated with " + relationTags.toString());
			}
		}

		private var _mappedBy:String;

		public function get mappedBy():String {
			return _mappedBy;
		}

		//is required by spicelib for setting the value.
		public function set mappedBy(value:String):void {
			_mappedBy = value;
		}

		public function isInverseSide():Boolean {
			return mappedBy == null;
		}

		protected function get name():String {
			throw new Error("get name() needs to be implmented in " + this)
		}

		public function toString(attachedTo:Object = null):String {
			return "[" + name + (!isInverseSide() ? "mappedBy='" + mappedBy + "'" : "") + "]" + (attachedTo != null ? " @ " + attachedTo : "");
		}

		public function validateCardinality(reflectionSource:Property):void {
			throw new Error("validateCardinality(reflectionSource:Property) needs to be implmented in " + this)
		}
	}
}
