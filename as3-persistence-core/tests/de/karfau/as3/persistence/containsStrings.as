/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 13:29
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence {
	import org.hamcrest.Matcher;
	import org.hamcrest.core.allOf;
	import org.hamcrest.text.containsString;

	public function containsStrings(...rest):Matcher {
		var contain:Array = [];
		for each(var s:String in rest) {
			contain.push(containsString(s));
		}
		return allOf(contain);
	}
}
