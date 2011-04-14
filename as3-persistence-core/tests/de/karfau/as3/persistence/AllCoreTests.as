/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence {
	import de.karfau.as3.persistence.domain.TestEntityFactory;
	import de.karfau.as3.persistence.domain.metatag.TestMetadataTags;
	import de.karfau.as3.persistence.domain.type.TestTypeUtil;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AllCoreTests {
		//public var _TestPersistentDomain:TestPersistentDomain;
		public var _TestEntityFactory:TestEntityFactory;
		public var _TestMetadataTags:TestMetadataTags;
		public var _TestTypeUtil:TestTypeUtil;

	}
}
