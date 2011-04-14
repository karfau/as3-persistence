/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 21:36
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.type.IType;

	public interface IProperty {
		function get name():String;

		function getType():IType;

	}
}
