/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 10:39
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import com.jeremyruppel.operations.base.Operation;

	import de.karfau.as3.persistence.operation.IConnectionOperation;
	import de.karfau.as3.persistence.sqlite.connection.BaseSQLConnectionParams;

	import flash.data.SQLConnection;

	public class ConnectionOperation extends AbstractSequenceOperation {

		private var connection:SQLConnection;

		public function ConnectionOperation(connection:SQLConnection) {
			this.connection = connection;
			super(null, Error, function start(operation:Operation):void {

			});
		}

		public function connectWith(parameter:BaseSQLConnectionParams):IConnectionOperation {

			if (parameter == null) {
				throw new ArgumentError("parameter needs to be of type BaseSQLConnectionParams.");
			}
			//TODO: operation.onConnect(function rememberConnectionParams():void{})

			var responderOperation:ConnectionResponderOperation = new ConnectionResponderOperation();

			addFaillableResponderOperationTo(sequence, responderOperation,
			function execution(responderOperation:ConnectionResponderOperation):void {
				responderOperation.connect(connection, parameter);
			});

			if (!calling) {
				call();
			}

			return responderOperation;
		}

	}
}

import de.karfau.as3.persistence.operation.BaseResponderOperation;
import de.karfau.as3.persistence.operation.IConnectionOperation;
import de.karfau.as3.persistence.sqlite.connection.BaseSQLConnectionParams;

import flash.data.SQLConnection;

class ConnectionResponderOperation extends BaseResponderOperation implements IConnectionOperation {

	public function onConnect(handler:Function):IConnectionOperation {
		addSucessHandler(handler);
		return this;
	}

	public function onConnectionFailed(handler:Function):IConnectionOperation {
		addErrorHandler(handler);
		return this;
	}

	public function connect(connection:SQLConnection, parameter:BaseSQLConnectionParams):void {

		if (parameter == null) {
			throw new ArgumentError("parameter needs to be of type BaseSQLConnectionParams.");
		}
		//TODO: operation.onConnect(function rememberConnectionParams():void{})
		if (!connection.connected) {
			connection.openAsync(parameter.reference, parameter.openMode$, responder,
													parameter.autoCompact, parameter.pageSize, parameter.encryption);
		} else {
			connection.attach(parameter.referenceName, parameter.reference, responder, parameter.encryption);
		}

	}

}