package ui
{
	import flash.events.Event;

	public class ListDataEvent extends Event
	{
		public static const REMOVE:String = "remove";
		public var data:*;
		
		public function ListDataEvent(type:String, data:*)
		{
			super(type, true, true);
			this.data = data;
		}
			
		override public function clone() : Event {
			return new ListDataEvent(type, data);
		}
	}
}