/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 20:49
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {

	public class EntityVisitorStub implements IEntityVisitor {

		public var visited:Vector.<Entity> = new Vector.<Entity>();

		public function visitEntity(entity:IEntity):void {
			visited.push(entity);
		}
	}
}
