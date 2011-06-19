/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 08.02.11
 * Time: 11:44
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.metatag.*;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagManyToMany;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagManyToOne;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToMany;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagOneToOne;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;
	import de.karfau.as3.persistence.domain.type.IType;
	import de.karfau.as3.persistence.domain.type.TypeUtil;
	import de.karfau.as3.persistence.domain.type.property.ClassPropertiesAnalysis;
	import de.karfau.as3.persistence.domain.type.property.EntityProperty;
	import de.karfau.as3.persistence.domain.type.property.IIdentifier;
	import de.karfau.as3.persistence.domain.type.property.NumericIdentifier;

	import flash.utils.getQualifiedClassName;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Metadata;
	import org.spicefactory.lib.reflect.Property;
	import org.spicefactory.lib.reflect.types.Private;

	public class EntityFactory {

		{
			Metadata.registerMetadataClass(MetaTagEntity);
			Metadata.registerMetadataClass(MetaTagId);
			Metadata.registerMetadataClass(MetaTagArrayElementType);
			Metadata.registerMetadataClass(MetaTagTransient);
			//Relations:
			Metadata.registerMetadataClass(MetaTagOneToOne);
			Metadata.registerMetadataClass(MetaTagOneToMany);
			Metadata.registerMetadataClass(MetaTagManyToOne);
			Metadata.registerMetadataClass(MetaTagManyToMany);
		}

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

		public function createEntity(clazz:Class):IEntity {

			if (clazz == null)
				throw expectedPersistableClassButWas(null);

			var type:IType = _typeRegister.getTypeForClass(clazz);
			var result:Entity;

			if (type is IEntity) {
				result = Entity(type);
			} else {
				const info:ClassPropertiesAnalysis = ClassPropertiesAnalysis.forClass(clazz);

				validatePersistableEntity(info);

				var identifier:IIdentifier = createIdentifier(info.identifiers[0]);

				result = new Entity(info.getClass());
				result.persistenceName = detectPersistenceName(info.classInfo);

				result.identifier = identifier;
				for each(var property:Property in info.persistableProperties) {
					if (property.name != identifier.name)
						result.setProperty(createEntityProperty(property));
				}

				typeRegister.registerType(result);
			}

			return result;
		}

		protected function detectPersistenceName(ci:ClassInfo):String {
			var meta:MetaTagEntity = MetaTagEntity.fromClassInfo(ci);
			return meta ? meta.name : ci.simpleName;
		}

		protected function validatePersistableEntity(info:ClassPropertiesAnalysis):void {
			if (!info.hasPersistableProperties()) {
				throw expectedPersistableClassButWas(info.classInfo.getClass(), "which has no property that is readable and writable and not [Transient].");
			}
			if (!info.hasIdentifiers()) {
				throw expectedPersistableClassButWas(info.getClass(), "which has no detectable primary key.");
			}
			if (info.identifiers.length > 1) {
				var names:Array = [];
				for each(var prop:Property in info.identifiers) {
					names.push("'" + prop.name + "'" + prop.type.getClass())
				}
				throw new SyntaxError("Expected exactly 1 property as primary key, but in class " + info.getClass() +
															" the properties\n\t" + names.join(" and ") + "\nwere detected as primary keys.");
			}
		}

		protected function createIdentifier(source:Property):IIdentifier {

			try {
				var result:NumericIdentifier = new NumericIdentifier(source.type.getClass());
			} catch(error:ArgumentError) {
				throw new SyntaxError("Expected a numeric property as primary key, but property '" + source.name + "' " +
															"in class '" + source.owner.name + "' is of type <" + source.type.name + ">.");
			}

			result.fromReflectionSource(source);
			return result;
		}

		protected function createEntityProperty(source:Property):EntityProperty {
			var rawClass:Class = source.type.getClass();
			var persistentClass:Class;
			if (TypeUtil.isCollectionType(rawClass)) {
				persistentClass = TypeUtil.getCollectionElementType(rawClass);
				if (persistentClass == null) {
					var meta:MetaTagArrayElementType = MetaTagArrayElementType.fromProperty(source);
					if (meta)
						persistentClass = meta.type.getClass();
				} else if (persistentClass == Private) {
					persistentClass = null;
					//  throw new IllegalOperationError("Persistence of private classes is not supported.");
				}
			}
			var result:EntityProperty = new EntityProperty(rawClass, persistentClass);
			result.fromReflectionSource(source);
			return result;
		}

	}
}
