/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 14.04.11
 * Time: 20:08
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {

	public class Collection extends Blob {

		private var _elementClass:Class;

		public function get elementClass():Class {
			return _elementClass;
		}

		public function Collection(clazz:Class, elementClass:Class) {
			super(clazz);
			_elementClass = elementClass;
		}

		override protected function describeInstance(...rest):Object {
			return super.describeInstance(rest.concat({elementClass:elementClass}));
		}
	}
}
