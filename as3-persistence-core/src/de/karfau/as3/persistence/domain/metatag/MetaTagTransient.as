/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 22:26
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import org.spicefactory.lib.reflect.Property;

	[Metadata(name="Transient",types="property")]
	public class MetaTagTransient {

		public static const NAME:String = "Transient";

		public static function fromProperty(source:Property):MetaTagTransient {
			return getMetaTagSecure(source, MetaTagTransient) as MetaTagTransient;
		}
	}
}
