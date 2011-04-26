/**
 * Created by IntelliJ IDEA.
 * User: Karfau
 * Date: 26.04.11
 * Time: 23:24
 * To change this template use File | Settings | File Templates.
 */
package de.karfau.as3.persistence.domain.model.analysis {
	import de.karfau.as3.persistence.domain.MetaModel;
	import de.karfau.as3.persistence.domain.model.BaseModelIterator;
	import de.karfau.as3.persistence.domain.type.Entity;
	import de.karfau.as3.persistence.domain.type.IEntity;

	import org.spicefactory.lib.reflect.ClassInfo;

	public class ModelInheritanceAnalysis extends BaseModelIterator {

		public function ModelInheritanceAnalysis(model:MetaModel) {
			super(model);
		}

		override public function visitEntity(entity:IEntity):void {
			var superClass:Class = entity.getClassInfo().getSuperClass();
			while (!(model.isRegisteredEntityType(superClass) || superClass == Object)) {
				superClass = ClassInfo.forClass(superClass).getSuperClass();
			}
			if (model.isRegisteredEntityType(superClass))
				Entity(entity).superEntity = model.getRegisteredEntityType(superClass);
		}
	}
}
