/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 19.04.11
 * Time: 13:15
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence {
	import de.karfau.as3.persistence.connection.IConnectionOperation;
	import de.karfau.as3.persistence.connection.IConnectionParams;
	import de.karfau.as3.persistence.domain.MetaModel;

	public interface IPersistanceProvider {

		function connect(parameter:IConnectionParams):IConnectionOperation;

		function get metaModel():MetaModel;

		function finalizeMetaModel():Boolean;

	}
}
