/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 12:34
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import org.spicefactory.lib.reflect.ClassInfo;

	[Metadata(name="Entity",types="class")]
	public class MetaTagEntity {

		public static const NAME:String = "Entity";

		public static function fromClassInfo(ci:ClassInfo):MetaTagEntity {
			return getMetaTagSecure(ci, MetaTagEntity) as MetaTagEntity;
		}

		[DefaultProperty]
		public var name:String;
	}
}
