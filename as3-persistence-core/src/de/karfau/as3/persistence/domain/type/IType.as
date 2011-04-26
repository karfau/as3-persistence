/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 13.04.11
 * Time: 09:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.type {
	import org.spicefactory.lib.reflect.ClassInfo;

	public interface IType {

		function getClassInfo():ClassInfo;

		function get clazz():Class;

		function getSimpleName():String;

		function getQualifiedName():String;

		function toString():String;

		/*function clone():IType;*/
	}
}
