/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 10:19
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	public interface IMetaTagRelation {

		function get mappedBy():String;

		function isInverseSide():Boolean;

		function toString(attachedTo:Object = null):String;
	}
}
