package ui4
{
	import mx.collections.IList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	
	import spark.components.List;
	
	public class LogList extends List
	{
		public function LogList()
		{
			super();
			
			_autoScroll = false;
			_scrollTo = -1;
			addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
		}
		
		private var _autoScroll:Boolean;
		private var _scrollTo:int;

		public function get autoScroll():Boolean
		{
			return _autoScroll;
		}

		public function set autoScroll(value:Boolean):void
		{
			_autoScroll = value;
		}

		override public function set dataProvider(value:IList):void
		{
			super.dataProvider = value;
			
			value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
		}
		
		private function onCollectionChange(event:CollectionEvent) : void {
			if(_autoScroll && event.kind == CollectionEventKind.ADD){
				_scrollTo = event.location;
			}
		}	
		
		private function onUpdateComplete(event:FlexEvent) : void {
			if(_scrollTo > 0){
				ensureIndexIsVisible(_scrollTo);
				_scrollTo = -1;
			}
		}
	}
}