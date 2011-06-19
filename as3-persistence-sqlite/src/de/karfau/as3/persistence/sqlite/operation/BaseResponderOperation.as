/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 11:33
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operation {
	import flash.errors.IllegalOperationError;
	import flash.net.Responder;

	public class BaseResponderOperation {

		private var _responder:Responder;
		public function get responder():Responder {
			if (_responder == null) {
				_responder = new Responder(responderSuccess, responderError);
			}
			return _responder;
		}

		private function responderSuccess(...rest):void {
			applyResult(true, rest);
		}

		private function responderError(...rest):void {
			applyResult(false, rest);
		}

		protected function applyResult(success:Boolean, arguments:Array):void {
			if (hasResult())
				throw new IllegalOperationError("Result has already been set.");
			_resultType = success ? ResultType.SUCCESS : ResultType.ERROR;
			_resultArgs = arguments;
			dispatchResult();
		}

		private var _resultArgs:Array;
		public function get resultArgs():Array {
			return _resultArgs;
		}

		private var _resultType:ResultType;
		public function get resultType():ResultType {
			return _resultType;
		}

		protected function hasResult():Boolean {
			return _resultType != null;
		}

		private var successHandlers:Array;
		private var errorHandlers:Array;

		private function get resultHandlers():Array {
			if (_resultType == null)
				return null;
			return _resultType.value ? successHandlers : errorHandlers;
		}

		public function addSucessHandler(handler:Function):void {
			if (successHandlers == null) {
				successHandlers = [];
			}
			successHandlers.push(handler);
			dispatchResult();
		}

		public function addErrorHandler(handler:Function):void {
			if (errorHandlers == null) {
				errorHandlers = [];
			}
			errorHandlers.push(handler);
			dispatchResult();
		}

		protected function dispatchResult():void {
			if (hasResult() && resultHandlers != null) {

				for each(var handler:Function in resultHandlers) {
					if (handler.length == 0) {
						handler.call();
					} else if (handler.length < _resultArgs.length) {
						handler.apply(null, _resultArgs.splice(handler.length));
					} else {
						handler.apply(null, _resultArgs);
					}
				}

				successHandlers = null;
				errorHandlers = null;
			}
		}

	}
}
