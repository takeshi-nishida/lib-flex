package tournament
{
	import mx.core.UIComponent;

	public class TournamentHBar extends UIComponent
	{
		public function TournamentHBar(t:Tournament, branch:Boolean)
		{
			super();
			
			this.branch = branch;
			this.leftWon = false;
			this.rightWon = false;
			this.t = t;
			this.toolTip = t.toString();
			t.addEventListener(TournamentEvent.DETERMINED, determined);
		}
		
		private var t:Tournament;
		private var branch:Boolean;
		private var leftWon:Boolean;
		private var rightWon:Boolean;

		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			graphics.lineStyle(leftWon || rightWon ? 8 : 2, 0x000000, 1);
			graphics.moveTo(0, unscaledHeight / 2);
			graphics.lineTo(unscaledWidth, unscaledHeight / 2);
			
			if(branch){
				graphics.moveTo(unscaledWidth, 0);
				graphics.lineStyle(leftWon ? 8 : 2, 0x000000, 1);
				graphics.lineTo(unscaledWidth, unscaledHeight / 2);
				graphics.lineStyle(rightWon ? 8 : 2, 0x000000, 1);
				graphics.lineTo(unscaledWidth, unscaledHeight);
			}
		}
		
		public function determined(e:TournamentEvent) : void {
			if(e.left){
				leftWon = true;
			}
			else{
				rightWon = true;
			}
			invalidateDisplayList();
		}
	}
}