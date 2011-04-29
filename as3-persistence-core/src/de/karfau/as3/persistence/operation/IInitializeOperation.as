/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 12:33
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.operation {
	public interface IInitializeOperation {
		function onInitializeComplete(handler:Function):IInitializeOperation;

		function onInitializeFailed(handler:Function):IInitializeOperation;
	}
}
