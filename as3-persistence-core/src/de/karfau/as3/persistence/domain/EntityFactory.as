/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 11:44
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.metatag.*;
	import de.karfau.as3.persistence.domain.type.Blob;
	import de.karfau.as3.persistence.domain.type.Collection;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IType;
	import de.karfau.as3.persistence.domain.type.Primitive;
	import de.karfau.as3.persistence.domain.type.TypeUtil;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.NumericIdentifier;

	import flash.utils.getQualifiedClassName;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Metadata;
	import org.spicefactory.lib.reflect.Property;

	{
		Metadata.registerMetadataClass(MetaTagEntity)
		Metadata.registerMetadataClass(MetaTagId)
		//Metadata.registerMetadataClass(MetaTagTransient)
	}

	public class EntityFactory {

		public static const ID_PROPERTY_NAME:String = "id";

		private var _typeRegister:TypeRegister;

		public function get typeRegister():TypeRegister {
			return _typeRegister;
		}

		public function EntityFactory(typeRegister:TypeRegister = null) {
			_typeRegister = typeRegister || new TypeRegister();
		}

		private function expectedPersistableClassButWas(clazz:Class, append:String = null):ArgumentError {
			return new ArgumentError("Expected a persistable class but was '" + getQualifiedClassName(clazz) + "' " + append);
		}

		private function describeValueType(type:IType):String {
			return "which is a " + (type.isPrimitive() ? "primitive " : "") + "value-class.";
		}

		public function createEntity(clazz:Class):IEntity {

			if (clazz == null)
				throw expectedPersistableClassButWas(clazz);

			var type:IType = _typeRegister.getTypeForClass(clazz);
			var result:Entity;

			if (type == null) {
				const ci:ClassInfo = ClassInfo.forClass(clazz);
				result = initializeEntity(ci);

				result.persistenceName = detectPersistenceName(ci);

			} else if (type is IEntity) {
				result = Entity(type);
			} else if (type.isValue() || type.isPrimitive()) {
				throw expectedPersistableClassButWas(clazz, describeValueType(type));
			} else {
				throw expectedPersistableClassButWas(clazz, ": typeRegister returned the unexpected IType-instance " + type);
			}
			return result;
		}

		private function initializeEntity(ci:ClassInfo):Entity {

			var properties:Vector.<Property> = Vector.<Property>(ci.getProperties().filter(filterPersistableProperties));
			if (properties.length == 0) {
				throw expectedPersistableClassButWas(ci.getClass(), "which has no property that is readable and writable and " + "not [Transient].");
			}

			var pk:IIdentifier = detectPrimaryKey(properties, ci);
			if (pk == null)
				throw expectedPersistableClassButWas(ci.getClass(), "which has no detectable primary key." +
																														" Expecting a property with the name '" + ID_PROPERTY_NAME + "'" +
																														" or with [Id].");

			var result:Entity = new Entity(ci.getClass());
			typeRegister.registerType(result);
			//create all the types:
			var clazz:Class;
			var property:Property;
			for each(property in properties) {
				clazz = property.type.getClass();
				if (!typeRegister.hasTypeFor(clazz)) {
					typeRegister.registerType(createType(clazz));
				}
			}

			//initialize Entity properties
			result.identifier = pk;
			for each(property in properties) {
				result.setProperty(createProperty(property));
			}

			return result;
		}

		private function createType(clazz:Class):IType {
			if (TypeUtil.isPrimitiveType(clazz)) {
				return new Primitive(clazz);
			}
			if (TypeUtil.isCollectionType(clazz)) {
				var elementType:ClassInfo = TypeUtil.getCollectionElementType(clazz);
				trace("elementType: " + elementType.getClass())
				return new Collection(clazz, elementType.getClass());
			}
			return new Blob(clazz);
		}

		protected function detectPersistenceName(ci:ClassInfo):String {
			return ci.hasMetadata(MetaTagEntity) ? getMetaTagEntity(ci).name : ci.simpleName;
		}

		protected function detectPrimaryKey(properties:Vector.<Property>, ci:ClassInfo):IIdentifier {
			var property:Property;
			/*if (ci.hasMetadata(MetaTagId)) {
			 for each(property in properties) {
			 if (property.hasMetadata(MetaTagId)) {
			 return createIdentifier(property);
			 }
			 }
			 throw new SyntaxError("'" + ci.name + "' uses [Id] on a property that is not persistable.");
			 } else {*/
			property = ci.getProperty(ID_PROPERTY_NAME);
			if (property == null) {
				throw new SyntaxError("'" + ci.name + "' has no property for a primary key.")
			} else {
				return createIdentifier(property);
			}

		}

		private function createIdentifier(source:Property):IIdentifier {
			const clazz:Class = source.type.getClass();
			if (!TypeUtil.isNumericType(clazz))
				throw new SyntaxError("Expected a numeric property as primary key, but property '" + source.name + "' " +
															"in class '" + source.owner.name + "' is of type <" + source.type.name + ">.");
			var result:NumericIdentifier = new NumericIdentifier(clazz, typeRegister);
			result.fromReflectionSource(source);

			return result;
		}

		protected function createProperty(source:Property):EntityProperty {
			var result:EntityProperty = new EntityProperty(source.type.getClass(), typeRegister);
			result.fromReflectionSource(source);
			return result;
		}

		protected function getMetaTagEntity(classinfo:ClassInfo):MetaTagEntity {
			return MetaTagEntity(classinfo.getMetadata(MetaTagEntity)[0]);
		}

		protected function getMetaTagId(classinfo:ClassInfo):MetaTagId {
			return MetaTagId(classinfo.getMetadata(MetaTagId)[0]);
		}

		protected function filterPersistableProperties(item:Property, index:int, array:Array):Boolean {
			var result:Boolean = item.readable && item.writable && !item.hasMetadata("Transient");
			return result;
		}
	}
}
