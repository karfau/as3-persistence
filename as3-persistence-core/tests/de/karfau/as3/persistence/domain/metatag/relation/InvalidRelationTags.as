/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 12:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {

	public class InvalidRelationTags {

		[OneToMany]
		[ManyToMany]
		public var multiple:Array;

		[OneToOne]
		public var oto_collection:Array;
		[ManyToOne]
		public var mto_collection:Array;
		[OneToMany]
		public var otm_single_value:Object;
		[ManyToMany]
		public var mtm_single_value:Object;
	}
}
