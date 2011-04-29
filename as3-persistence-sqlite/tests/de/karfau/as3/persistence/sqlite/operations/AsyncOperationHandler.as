/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 29.04.11
 * Time: 20:11
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.operations {
	import flash.events.EventDispatcher;

	import org.flexunit.async.Async;

	public class AsyncOperationHandler {

		private var dispatcher:EventDispatcher = new EventDispatcher();

		private var testCase:Object;
		private var timeout:uint;

		public function AsyncOperationHandler(testCase:Object, timeout:uint) {
			this.testCase = testCase;
			this.timeout = timeout;
		}

		private var eventTypeCounter:uint = 0;

		//private var timeoutHandler:Function;

		/*public function onTimeout(handler:Function):AsyncOperationHandler{
		 function timeOutWrapper(...rest):void{
		 dispatcher.dispatchEvent(new Event("expected#"+(eventTypeCounter++)));
		 handler();
		 };
		 return this;
		 }*/

		public function addExpectedHandler(handler:Function):Function {
			var evtType:String = "expected#" + (eventTypeCounter++);

			function handlerWrapper(event:PassingEvent, ...rest):void {
				trace(evtType + " : handlerWrapper(event,...rest)")
				handler.apply(null, event.passThrough);
			}

			Async.handleEvent(testCase, dispatcher, evtType, handlerWrapper, timeout);

			function dispatching(...relevant):void {
				trace(evtType + " : dispatching(" + relevant + ")");
				dispatcher.dispatchEvent(new PassingEvent(evtType, relevant));
			}

			return dispatching;
		}

		public function createFailingHandler(handler:Function = null):Function {
			var evtType:String = "error#" + (eventTypeCounter++);

			Async.registerFailureEvent(testCase, dispatcher, evtType);

			function dispatching(error:Error):void {
				trace(evtType + " : dispatching(" + error + ")");
				if (handler != null)
					handler(error);
				//fail("failingHandler " + evtType + " was triggered By " + error);
				dispatcher.dispatchEvent(new ErrorEvent(evtType, error));
			}

			return dispatching;
		}

	}
}

import flash.events.Event;

class PassingEvent extends Event {
	public var passThrough:Array;

	function PassingEvent(type:String, passThrough:Array) {
		super(type);
		this.passThrough = passThrough;
	}

	override public function clone():Event {
		return new PassingEvent(type, passThrough.slice());
	}
}

class ErrorEvent extends Event {
	public var error:Error;

	function ErrorEvent(type:String, error:Error) {
		super(type);
		this.error = error;
	}

	override public function toString():String {
		return "failingHandler " + type + " was triggered By " + error;
	}

	override public function clone():Event {
		return new ErrorEvent(type, error);
	}
}

