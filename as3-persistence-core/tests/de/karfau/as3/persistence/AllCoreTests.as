/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 13:31
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence {
	import de.karfau.as3.persistence.domain.TestEntityFactory;
	import de.karfau.as3.persistence.domain.TestMetaModel;
	import de.karfau.as3.persistence.domain.metatag.TestMetadataTags;
	import de.karfau.as3.persistence.domain.metatag.relation.TestMetaTagRelationBase;
	import de.karfau.as3.persistence.domain.photos.TestComplexModel;
	import de.karfau.as3.persistence.domain.type.TestTypeRegister;
	import de.karfau.as3.persistence.domain.type.TestTypeUtil;
	import de.karfau.as3.persistence.domain.type.property.TestClassPropertiesAnalysis;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AllCoreTests {
		public var _TestEntityFactory:TestEntityFactory;
		public var _TestMetadataTags:TestMetadataTags;
		public var _TestTypeUtil:TestTypeUtil;
		public var _TestClassPropertiesAnalysis:TestClassPropertiesAnalysis;
		public var _TestTypeRegister:TestTypeRegister;
		public var _TestMetaModel:TestMetaModel;
		public var _TestMetaTagRelationBase:TestMetaTagRelationBase;
		public var _TestComplexModel:TestComplexModel;
	}
}
