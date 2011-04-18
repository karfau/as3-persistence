/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 20:12
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {

	public interface IEntityVisitor {

		function visitEntity(entity:IEntity):void;
	}
}
