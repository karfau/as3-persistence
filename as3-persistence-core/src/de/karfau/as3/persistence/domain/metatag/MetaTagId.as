/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 21:28
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import org.spicefactory.lib.reflect.Property;

	[Metadata(name="Id",types="property")]
	public class MetaTagId {

		public static const NAME:String = "Id";

		public static function fromProperty(source:Property):MetaTagId {
			return getMetaTagSecure(source, MetaTagId) as MetaTagId;
		}

	}
}
