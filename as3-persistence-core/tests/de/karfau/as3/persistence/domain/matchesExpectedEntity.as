package de.karfau.as3.persistence.domain {
	import de.karfau.as3.persistence.domain.type.IEntity;

	import org.hamcrest.Matcher;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;

	public function matchesExpectedEntity(clazz:Class, persistenceName:String):Matcher {
		return		allOf(notNullValue(), instanceOf(IEntity),
									 hasPropertyWithValue("clazz", clazz),
									 hasPropertyWithValue("persistenceName", equalTo(persistenceName))

									 );
	}

}
