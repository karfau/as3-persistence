/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 22:04
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.connection {
	import flash.utils.ByteArray;

	public interface IConnectionParams {

		function get reference():Object;

		function get referenceName():String;

		function get openMode():ConnectionMode;

		function get encryption():ByteArray;
	}
}
