/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 22:22
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {

	[Entity(name="ExplicitlyNamedEntity")]
	public class EmptyEntityWithExplicitNaming {
		internal static const ENTITY_NAME:String = "ExplicitlyNamedEntity";

		public function EmptyEntityWithExplicitNaming() {
		}
	}
}
