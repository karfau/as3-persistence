/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 12.04.11
 * Time: 17:25
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.photos {
	import de.karfau.as3.persistence.domain.meta;

	/**
	 * This class is an example for a persistable class without any metadata.
	 *
	 */
	public class Photo {

		meta static const SIMPLE_NAME:String = "Photo";

		/**
		 * this will be used as primary key because of its name.
		 */
		public var id:int;

		/**
		 * It depends on the implementation how this will be persisted. Could be a blob or a String like "&lt;1,2,3&gt;" or as an EmbeddedCollection
		 */
		public var histogram:Vector.<int>;

		public var title:String;

		/**
		 * Dateconversion has to take place in the implementation.
		 */
		public var time_of_creation:Date;

		[OneToOne]
		/**
		 * "?-To-One"-Relation, unidirectional
		 */
		public var location:GeoLocation;

		[ManyToOne(mappedBy="photos")]
		[Required]
		/**
		 * "Many-To-One"-Relation, bidirectional
		 */
		public var device:Camera;

		[ManyToMany]
		/**
		 * "Many-To-Many"-Relation, bidirectional
		 */
		public var motifes:Vector.<Motif>;
	}
}
