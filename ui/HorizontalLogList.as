package ui
{
	import mx.collections.ICollectionView;
	import mx.controls.HorizontalList;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;

	[Bindable]
	public class HorizontalLogList extends HorizontalList
	{		
		public function HorizontalLogList()
		{
			super();
			
			_autoScroll = true;
			_scrollTo = -1;
			addEventListener(FlexEvent.UPDATE_COMPLETE, onUpdateComplete);
		}
		
		public function set autoScroll(value:Boolean) : void {
			_autoScroll = value;
		}
		
		public function get autoScroll() : Boolean {
			return _autoScroll;
		}
				
		override public function set dataProvider(value:Object) : void {
			super.dataProvider = value;
			
			if(value is ICollectionView){
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onCollectionChange);
			}
		}

		private var _autoScroll:Boolean;
		private var _scrollTo:int;

		private function onCollectionChange(event:CollectionEvent) : void {
			if(_autoScroll && event.kind == CollectionEventKind.ADD && event.location + 1 >= event.target.length){
				_scrollTo = event.location;
			}
		}
		
		private function onUpdateComplete(event:FlexEvent) : void {
			if(_scrollTo > 0){
				scrollToIndex(_scrollTo + 1);
				_scrollTo = -1;
			}
		}
	}
}