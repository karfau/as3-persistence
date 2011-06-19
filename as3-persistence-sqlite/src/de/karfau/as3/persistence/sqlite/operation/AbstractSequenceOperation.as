/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 30.04.11
 * Time: 14:35
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import com.jeremyruppel.operations.base.Operation;
	import com.jeremyruppel.operations.core.IOperationGroup;
	import com.jeremyruppel.operations.group.OperationQueue;

	public class AbstractSequenceOperation extends Operation {

		protected var sequence:OperationQueue = new OperationQueue();

		public function AbstractSequenceOperation(successClass:Class, failureClass:Class, firstBlock:Function /*TODO: more blocks already?*/) {
			super(successClass, failureClass, function main(operation:Operation):void {
				addFailableOpeartionTo(sequence, firstBlock);
				sequence.failed.add(fail);
				sequence.succeeded.add(operation.succeed);
				sequence.call();
			});
		}

		protected final function createFailableOperation(block:Function, ...arguments):Operation {
			return new Operation(_successClass, Error, function failableBlock(operation:Operation):void {
				try {
					if (arguments.length == 0) {
						block(operation);
					} else {
						if (block.length > arguments.length)
							arguments = [operation].concat(arguments);
						block.apply(null, arguments);
					}
				} catch(error:Error) {
					fail(error);
				}
			});
		}

		protected final function addFailableOpeartionTo(group:IOperationGroup, block:Function):void {
			group.add(createFailableOperation(block));
		}

		protected function addFaillableResponderOperationTo(group:IOperationGroup, responderOperation:BaseResponderOperation, execution:Function):void {
			addFailableOpeartionTo(group, function execute(operation:Operation):void {
				responderOperation.addSucessHandler(operation.succeed);
				responderOperation.addErrorHandler(fail);
				execution(responderOperation);
			});
		}

		public var releaseHandler:Function;

		override protected function release():void {
			if (releaseHandler != null)
				releaseHandler();

			super.release();
		}

		protected function addFailedHandler(handler:Function):void {
			failed.add(handler);
			if (delayedFail != null) {
				delayedFail();
			}
		}

		private var delayedFail:Function;

		override public function fail(payload:* = null):void {
			if (!(payload is Error)) {
				payload = new Error("The main sequence failed in an unecpected way. Expected an Error-instance as parameter but was: " + payload);
			}
			if (failed.numListeners == 0) {
				delayedFail = function callWrapper():void {
					fail(payload);
				}
			} else {
				super.fail(payload);
			}
		}

		protected function addSuccessHandler(handler:Function):void {
			succeeded.add(handler);
			if (delayedSucceed != null) {
				delayedSucceed();
			}
		}

		private var delayedSucceed:Function;

		override public function succeed(payload:* = null):void {
			if (succeeded.numListeners == 0) {
				delayedSucceed = function callWrapper():void {
					succeed(payload);
				}
			} else {
				super.succeed(payload);
			}
		}
	}
}
