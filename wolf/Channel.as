package wolf
{
	public final class Channel
	{
		public static const main:Channel = new Channel("main", "村の話し合い", 0xffffff);
		public static const wolf:Channel = new Channel("wolf", "狼のささやき", 0xff7777);
		public static const dead:Channel = new Channel("dead", "墓のうめき声", 0x9fb7cf);
		public static const self:Channel = new Channel("self", "独り言", 0xd3d3d3);
		
		public static const all:Array = [main, wolf, dead, self];

		private var _name:String;
		private var _label:String;
		private var _color:uint;
		
		public function Channel(name:String, label:String, color:uint) {
			_name = name;
			_label = label;
			_color = color;
		}
		
		public function toString() : String {
			return _name;
		}
		
		public function get label() : String {
			return _label;
		}
		
		public function get color() : uint {
			return _color;
		}
	}
}