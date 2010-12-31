package util
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class ArrayCollectionMap extends ArrayCollection
	{
		private var map:Dictionary;
		private var _maxId:int;
		
		public function ArrayCollectionMap(source:Array=null)
		{
			super(source);
			sort = new Sort();
			var sortById:SortField = new SortField();
			sortById.name = "id";
			sortById.numeric = true;
			sort.fields = [sortById];
			refresh();
			map = new Dictionary();

			_maxId = 0;
		}
		
		public override function addItem(item:Object) : void {
			if(!map[item.id]){
				_maxId = Math.max(_maxId, item.id);
				map[item.id] = item;
				super.addItem(item);
			}
		}
				
		public function getItem(id:int) : Object {
			return map[id];
		}
		
		public function removeItem(id:int) : void {		  
			if(map[id]){
			  trace(super.contains(map[id]));
				var index:int = getItemIndex(map[id]);
				map[id] = null;
				if(index >= 0){
					removeItemAt(index);
				}
			}
		}
		
		public override function removeAll() : void {
		  map = new Dictionary();
		  super.removeAll();
		}
		
		public function get maxId() : int {
			return _maxId;
		}
	}
}