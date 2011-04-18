/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 21:35
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;

	[Metadata(name="ArrayElementType",types="property")]
	public class MetaTagArrayElementType {

		public static const NAME:String = "ArrayElementType";

		public static function fromProperty(source:Property):MetaTagArrayElementType {
			return getMetaTagSecure(source, MetaTagArrayElementType) as MetaTagArrayElementType;
		}

		[Required]
		[DefaultProperty]
		public var type:ClassInfo;
	}
}
