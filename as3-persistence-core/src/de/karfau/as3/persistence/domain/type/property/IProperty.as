/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 21:36
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type.property {
	import de.karfau.as3.persistence.domain.metatag.relation.IMetaTagRelation;
	import de.karfau.as3.persistence.domain.model.IRelation;
	import de.karfau.as3.persistence.domain.type.IEntity;

	public interface IProperty {
		function get name():String;

		function get declaredBy():IEntity;

		function get rawClass():Class;

		function get persistentClass():Class;

		function isCollection():Boolean;

		function accept(visitor:IPropertyVisitor):void;

		function get relationTag():IMetaTagRelation;

		function get relation():IRelation;

		function isOwningRelation():Boolean;

		function getRelatedEntity():IEntity;

		function getRelatedProperty():IProperty;

		function toString():String;
	}
}
