/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 09:53
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.metatag.relation {
	[Metadata(name="OneToOne",types="property")]
	public class MetaTagOneToOne extends AbstractMetaTagToOne {

		public static const NAME:String = "OneToOne";

		override protected function get name():String {
			return NAME;
		}

		public function MetaTagOneToOne() {
			super(MetaTagOneToOne);
		}
	}
}
