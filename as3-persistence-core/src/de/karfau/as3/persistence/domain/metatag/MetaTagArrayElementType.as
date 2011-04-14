/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 21:35
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag {

	[Metadata(name="ArrayElementType",types="property")]
	public class MetaTagArrayElementType {
		public static const NAME:String = "ArrayElementType";

		[Required]
		[DefaultProperty]
		public var type:Class;
	}
}
