/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {

	/**
	 * identifiers : pk,pk2 ;
	 * persistable properties : id,pk,pk2 (all)
	 *
	 * all Properties are persistable, but only pk and pk2 are identifiers,
	 * because if [Id] is found, property with name is not searched for.
	 */
	public class IdentifierMetaPropertiesExample {

		public var id:uint;

		[Id]
		public var pk:String;

		[Id]
		public var pk2:String;

	}
}
