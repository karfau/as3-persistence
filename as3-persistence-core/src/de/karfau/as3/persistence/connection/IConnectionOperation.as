/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 18:04
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.connection {
	public interface IConnectionOperation {

		function onConnect(handler:Function):IConnectionOperation;

		function onConnectionFailed(handler:Function):IConnectionOperation;

	}
}
