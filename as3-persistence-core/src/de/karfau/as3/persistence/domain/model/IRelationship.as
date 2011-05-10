/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 29.04.11
 * Time: 09:34
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model {
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;

	public interface IRelationship {
		function get owningProperty():EntityProperty;

		function get owningEntity():IEntity;

		function get inverseEntity():Entity;

		function get inverseProperty():EntityProperty;

		function isBidirectional():Boolean;

		function hasNavigableManySide():Boolean;

		function hasOneSide():Boolean;
	}
}
