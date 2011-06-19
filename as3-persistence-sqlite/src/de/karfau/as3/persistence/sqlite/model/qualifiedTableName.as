/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 27.04.11
 * Time: 14:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.sqlite.model {
	import de.karfau.as3.persistence.domain.type.IEntity;

	internal function qualifiedTableName(entity:IEntity):String {
		//TODO: persistanceUnit -> dbname
		return entity.hasSuperEntity() ? entity.superRootEntity.persistenceName : entity.persistenceName;
	}

}
