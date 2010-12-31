package tournament
{
	import flash.events.Event;

	public class TournamentEvent extends Event
	{
		public static const DETERMINED:String = "DETERMINED";
		public var left:Boolean;

		public function TournamentEvent(type:String, left:Boolean)
		{
			super(type, true, true);
			this.left = left;
		}

		override public function clone() : Event {
			return new TournamentEvent(type, left);
		}
	}
}