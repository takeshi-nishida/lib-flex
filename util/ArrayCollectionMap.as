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
		
		public function ArrayCollectionMap(shouldSortById:Boolean = true, source:Array=null)
		{
			super(source);
      if(shouldSortById){
  			sort = new Sort();
  			var sortById:SortField = new SortField();
  			sortById.name = "id";
  			sortById.numeric = true;
  			sort.fields = [sortById];
      }
			refresh();
			map = new Dictionary();

			_maxId = 0;
		}
		
//		public override function addItem(item:Object) : void {
//      trace("addItem");
//			if(!map[item.id]){
//				_maxId = Math.max(_maxId, item.id);
//				map[item.id] = item;
//				super.addItem(item);
//			}
//		}
    
    public override function addItemAt(item:Object, index:int) : void {
//      trace("addItemAt:" + index);
      if(!map[item.id]){
        _maxId = Math.max(_maxId, item.id);
        map[item.id] = item;
      }
      super.addItemAt(item, index);
    }
				
		public function getItem(id:int) : Object {
			return map[id];
		}
		
		public function removeItem(id:int) : void {		  
			if(map[id]){
				var index:int = getItemIndex(map[id]);
				map[id] = null;
				if(index >= 0){
					removeItemAt(index);
				}
			}
		}
    
    public override function removeItemAt(index:int) : Object{
//      trace("removeItemAt:" + index);
      var id:int = getItemAt(index).id;
      if(map[id]){
        map[id] = null;
      }
      return super.removeItemAt(index);
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