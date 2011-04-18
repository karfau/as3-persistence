/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 18.04.11
 * Time: 12:58
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {

	/**
	 * identifiers : none ;
	 * persistable properties : ID,iD,Id
	 *
	 * readonly,writeonly and transient are the criterias for not being persistable properties,
	 * ID,iD and Id are persistable properties, but no identifiers,
	 * because only "id"(casesensitive) would become one without [Id]
	 *
	 */
	public class PersistablePropertiesExample {

		private var _ID:uint;
		public function get ID():uint {
			return _ID;
		}

		public function set ID(value:uint):void {
			_ID = value;
		}

		public var iD:uint;
		public var Id:uint;

		private var _writeonly:String;
		public function set writeonly(value:String):void {
			_writeonly = value;
		}

		private var _readonly:String;
		public function get readonly():String {
			return _readonly;
		}

		[Transient]
		public var transient:String;

	}
}
