/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 22:44
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.metatag.relation.IMetaTagRelation;
	import de.karfau.as3.persistence.domain.metatag.relation.MetaTagRelationBase;
	import de.karfau.as3.persistence.domain.model.IRelationship;
	import de.karfau.as3.persistence.domain.type.IEntity;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Property;

	public class EntityProperty implements IProperty {
		protected var _name:String;

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		private var _declaredBy:IEntity;

		public function get declaredBy():IEntity {
			return _declaredBy;
		}

		public function set declaredBy(value:IEntity):void {
			_declaredBy = value;
		}

		private var _rawClass:Class;

		public function get rawClass():Class {
			return _rawClass;
		}

		private var _persistentClass:Class;

		public function get persistentClass():Class {
			return _persistentClass;
		}

		public function isCollection():Boolean {
			return rawClass != persistentClass;
		}

		private var _relationTag:MetaTagRelationBase;

		public function get relationTag():IMetaTagRelation {
			return _relationTag;
		}

		public function set relationTag(value:IMetaTagRelation):void {
			_relationTag = MetaTagRelationBase(value);
		}

		private var _relation:IRelationship;

		public function get relation():IRelationship {
			return _relation;
		}

		public function set relation(value:IRelationship):void {
			_relation = value;
		}

		public function EntityProperty(rawClass:Class, persistentClass:Class = null) {
			if (rawClass == null) {
				throw new ArgumentError("rawClass can not be null.");
			}
			_declaredBy = declaredBy;
			_rawClass = rawClass;
			_persistentClass = persistentClass == null ? _rawClass : persistentClass;
		}

		public function accept(visitor:IPropertyVisitor):void {
			visitor.visitProperty(this);
		}

		public function fromReflectionSource(source:Property):void {
			_name = source.name;
			relationTag = MetaTagRelationBase.fromProperty(source);
		}

		public function isOwningRelation():Boolean {
			return relation && relation.owningProperty == this;
		}

		public function getRelatedEntity():IEntity {
			var result:IEntity;
			if (relation) {
				result = isOwningRelation() ? relation.inverseEntity : relation.owningProperty.declaredBy;
			}
			return result;
		}

		public function getRelatedProperty():IProperty {
			var result:IProperty;
			if (relation) {
				result = isOwningRelation() ? relation.inverseProperty : relation.owningProperty;
			}
			return result;
		}

		public function toString():String {
			return "[Property " + name + " declared by " + declaredBy.getQualifiedName() + ": persistentClass=" +
						 ClassInfo.forClass(persistentClass).simpleName + (isCollection() ? "(collection)" : "") + "]";
		}

	}
}
