/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 17.04.11
 * Time: 23:30
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.metatag.MetaTagId;
	import de.karfau.as3.persistence.domain.metatag.MetaTagTransient;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;

	public class ClassPropertiesAnalysis {

		public static function forClass(clazz:Class):ClassPropertiesAnalysis {
			return new ClassPropertiesAnalysis(ClassInfo.forClass(clazz));
		}

		public static const IDENTIFIER_PROPERTY_NAME:String = "id";

		private var _classInfo:ClassInfo;

		public function get classInfo():ClassInfo {
			return _classInfo;
		}

		public function getClass():Class {
			return _classInfo.getClass();
		}

		private var _persistables:Vector.<Property> = new Vector.<Property>();

		public function hasPersistableProperties():Boolean {
			return _persistables.length > 0;
		}

		public function get persistableProperties():Vector.<Property> {
			return _persistables.slice();
		}

		private var _ids:Vector.<Property> = new Vector.<Property>();
		private var _id_by_name:Property;

		public function hasIdentifiers():Boolean {
			return _ids.length > 0;
		}

		public function get identifiers():Vector.<Property> {
			return _ids.slice();
		}

		public function ClassPropertiesAnalysis(classInfo:ClassInfo) {
			for each (var property:Property in classInfo.getProperties()) {
				addProperty(property);
			}
			finalizeIdentifiers();
			//to prevent access to classInfo inside filter-calls this is not available before filters are done:
			_classInfo = classInfo;
		}

		protected function addProperty(property:Property):void {
			if (filterPersistable(property)) {
				filterIdentifier(property);
			}
		}

		protected function filterPersistable(property:Property):Boolean {
			if (property.readable && property.writable && !property.hasMetadata(MetaTagTransient)) {
				_persistables.push(property);
				return true;
			}
			return false;
		}

		protected function filterIdentifier(persistableProperty:Property):Boolean {
			if (persistableProperty.hasMetadata(MetaTagId)) {
				_ids.push(persistableProperty);
				return true;
			}
			if (persistableProperty.name == IDENTIFIER_PROPERTY_NAME) {
				_id_by_name = persistableProperty;
				return true;
			}
			return false;
		}

		protected function finalizeIdentifiers():void {
			if (!hasIdentifiers() && _id_by_name != null) {
				_ids.push(_id_by_name);
			}
		}

	}
}
