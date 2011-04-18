/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {

	/**
	 * identifiers : none ;
	 * persistable properties : none
	 *
	 * because "id" is readonly
	 */
	public class IdentifierReadonlyPropertiesExample {

		private var _id:uint;

		public function get id():uint {
			return _id;
		}
	}
}
