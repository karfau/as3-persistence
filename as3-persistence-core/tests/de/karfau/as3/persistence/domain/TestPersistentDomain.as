/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 07.02.11
 * Time: 16:14
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain {
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.fail;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.*;
	import org.hamcrest.core.*;
	import org.hamcrest.object.*;

	import spectacular.*;

	[RunWith("spectacular.runners.SpectacularRunner")]
	public class TestPersistentDomain {

		public function TestPersistentDomain():void {

			describe("A PersistentDomain after being created", function ():void {

				var domain:PersistentDomain;

				before(function ():void {
					assertNull(domain);
					domain = new PersistentDomain();
				});

				after(function ():void {
					domain = null;
				});

				it("doesn't contain any entities", function ():void {
					assertThat(domain.getRegisteredEntities(), both(notNullValue()).and(arrayWithSize(0)));
				});

				describe("when adding a model class", function ():void {
					it("test", function ():void {
						assertThat(true);
					})
				});

			});

		}

		[Test]
		public function failingTest():void {
			fail("test");
		}
	}
}
