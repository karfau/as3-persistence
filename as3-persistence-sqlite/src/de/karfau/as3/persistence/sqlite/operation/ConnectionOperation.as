/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 10:39
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import de.karfau.as3.persistence.operation.BaseResponderOperation;
	import de.karfau.as3.persistence.operation.IConnectionOperation;

	public class ConnectionOperation extends BaseResponderOperation implements IConnectionOperation {

		public function onConnect(handler:Function):IConnectionOperation {
			addSucessHandler(handler);
			return this;
		}

		public function onConnectionFailed(handler:Function):IConnectionOperation {
			addErrorHandler(handler);
			return null;
		}

	}
}
