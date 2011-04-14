/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 20:18
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import flash.errors.IllegalOperationError;

	public class Motif {

		[Id]
		public var PK:int;

		public function getLabel():String {
			throw new IllegalOperationError("method has to be implemented by subclasses")
		}

		public var occurences:Array;

	}
}
