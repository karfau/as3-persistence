/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 17.04.11
 * Time: 23:03
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {
	import org.spicefactory.lib.reflect.MetadataAware;

	public function getMetaTagSecure(source:MetadataAware, metatag:Object):Object {
		return source.hasMetadata(metatag) ? source.getMetadata(metatag)[0] : null;
	}
}
