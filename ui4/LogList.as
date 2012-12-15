package ui4
{
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	import spark.events.IndexChangeEvent;
	
  [Bindable]
	public class LogList extends List
	{
    public var autoScrollInterval:Number = 2000;
		private var _autoScroll:Boolean;
		private var _autoSelect:Boolean;
		private var _added:Object;
    public var _lastMouseMoveTime:Number;

		public function LogList()
		{
			super();

      _autoScroll = false;
			_autoSelect = false;
			_added = null;
      _lastMouseMoveTime = new Date().time;
			addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
      addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		
		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}
    
    public function get willAutoScroll() : Boolean {
        return _autoScroll && (new Date().time - _lastMouseMoveTime) > autoScrollInterval;
    }
    		
		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
		}
        		
		public function get autoSelect() :Boolean
		{
			return _autoSelect;
		}
		
		public function set autoSelect(value:Boolean):void
		{
			_autoSelect = value;
		}
		
		override public function set dataProvider(value:IList):void
		{
			super.dataProvider = value;
			
			value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
				
		override public function set selectedItem(value:*):void
		{
			super.selectedItem = value;
			if(_autoScroll){
				ensureIndexIsVisible(dataProvider.getItemIndex(value));
			}
		}
		
		private function onCollectionChange(event:CollectionEvent) : void {
			switch(event.kind){
				case CollectionEventKind.ADD:
					_added = event.items[event.items.length - 1];
			}
		}	
		
		private function onUpdateComplete(event:FlexEvent) : void {
			if(_added){
				if(_autoSelect){
					selectedItem = _added;
				}
				if(willAutoScroll){
					ensureIndexIsVisible(dataProvider.getItemIndex(_added));
				}
				_added = null;
			}      
		}
    
    private function onMouseMove(event:MouseEvent) : void {
      _lastMouseMoveTime = new Date().time;
    }
    
	}
}