package tournament
{
	import flash.events.EventDispatcher;
	
	public class Tournament extends EventDispatcher
	{
		public function Tournament(players:Array, left:Tournament, right:Tournament, round:int)
		{
			_players = players;
			_left = left;
			_right = right;
			_round = round;
			
			_winner = _players.length == 1 ? players[0] : null;
			_winLeft = false;
		}

		private var _players:Array;		
		private var _left:Tournament;
		private var _right:Tournament;
		private var _round:int;
		private var _winner:Player;
		private var _winLeft:Boolean;
		
		public function get players() : Array {
			return _players;
		}
		
		public function get left() : Tournament {
			return _left;
		}
		
		public function get right() : Tournament {
			return _right;
		}
		
		public function get round() : int{
			return _round;
		}
		
		public function get winner() : Player {
			return _winner;
		}
		
		public function get winLeft() : Boolean {
			return _winLeft;
		}
		
		public override function toString() : String {
			return winner ? winner.toString() : "(" + left.toString() + " vs. " + right.toString() + ")";
		}

		public function containsPlayer(player:Player) : Boolean {
			return players.some(function(p:*, index:int, arr:Array) : Boolean { return Player.equals(player, p); });
		}
		
		
		public function wonBy(player:Player) : void {			
			if(!winner && this.containsPlayer(player)){
				var focusLeft:Boolean = left.containsPlayer(player);
				var t1:Tournament = focusLeft ? left : right;
				var t2:Tournament = focusLeft ? right : left;
				if(Player.equals(player, t1.winner) && t2.winner){
					_winner = player;
					_winLeft = focusLeft;
					if(t1.players.length == 1){
						t1.dispatchEvent(new TournamentEvent(TournamentEvent.DETERMINED, focusLeft));
					}
					dispatchEvent(new TournamentEvent(TournamentEvent.DETERMINED, focusLeft));					
				}
				else{
					t1.wonBy(player);
				}
			}
		}

		public static function createTournament(players:Array) : Tournament {
			if(players.length > 1){
				var l:Tournament = createTournament(players.slice(0, players.length / 2));
				var r:Tournament = createTournament(players.slice(players.length / 2, players.length));
				return new Tournament(players, l, r, Math.max(l.round, r.round) + 1);
			}
			else{
				return new Tournament(players, null, null, 0);
			}
		}
		
		public static function createTournamentFromString(s:String) : Tournament {
			var players:Array = new Array();
			for each(var id:String in s.split(" ")){
				players.push(new Player(id));
			}
			return createTournament(players);
		}
	}
}