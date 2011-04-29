/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 28.04.11
 * Time: 10:41
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.statement {
	import flash.errors.IllegalOperationError;

	public final class SQLType {

		private static const VALUES:Vector.<SQLType> = new Vector.<SQLType>();

		public static function forClass(clazz:Class):SQLType {
			for each (var result:SQLType in VALUES) {
				if (result.supportsType(clazz))
					return result;
			}
			return OBJECT;
		}

		private static var creationAllowed:Boolean = true;

		public static const TEXT:SQLType = new SQLType("TEXT", [String]);
		public static const XMLLIST:SQLType = new SQLType("XMLLIST", [XMLList]);
		public static const XML:SQLType = new SQLType("XML", [XML]);

		public static const OBJECT:SQLType = new SQLType("Object", [Object]);
		public static const BOOLEAN:SQLType = new SQLType("BOOLEAN", [Boolean]);
		public static const DATE:SQLType = new SQLType("DATE", [Date]);
		public static const INTEGER:SQLType = new SQLType("INTEGER", [int,uint]);

		public static const NUMERIC:SQLType = new SQLType("NUMERIC", [Number]);

		public static const NONE:SQLType = new SQLType("BLOB", []);

		{
			creationAllowed = false;
		}

		private var types:Vector.<Class> = new Vector.<Class>();

		public function supportsType(type:Class):Boolean {
			return types.indexOf(type) > -1;
		}

		private var output:String;

		public function SQLType(output:String, classes:Array) {
			if (!creationAllowed) {
				throw new IllegalOperationError("SQLType is an Enumeration, the only instances allowed exist as static constants.")
			}
			for each (var type:Class in classes) {
				types.push(type);
			}
			this.output = output;
			VALUES.push(this);
		}

		public function toString():String {
			return output;
		}
	}
}
