package tournament
{
	public class Player
	{
		public function Player(id:String)
		{
			_id = id;
		}
		
		private var _id:String;
		
		public function get id() : String {
			return _id;
		}
		
		public function toString() : String {
			return _id;
		}
		
		public static function equals(p1:Player, p2:Player) : Boolean {
			return p1 && p2 && p1.id == p2.id;
		}
	}
}