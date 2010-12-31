package tournament
{
	import mx.core.UIComponent;

	public class TournamentVBar extends UIComponent
	{
		public function TournamentVBar(t:Tournament, full:Boolean, left:Boolean)
		{
			super();
			
			this.full = full;
			this.left = left;
			this.won = false
			this.t = t;
			this.toolTip = t.toString();
			t.addEventListener(TournamentEvent.DETERMINED, determined);
		}
		
		private var t:Tournament;
		private var full:Boolean;
		private var left:Boolean;
		private var won:Boolean;

		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.lineStyle(won ? 8 : 2, 0x000000, 1);

			if(full){
				graphics.moveTo(unscaledWidth, 0);
				graphics.lineTo(unscaledWidth, unscaledHeight);
			}
			else{
				graphics.moveTo(unscaledWidth, unscaledHeight / 2);
				graphics.lineTo(unscaledWidth, left ? unscaledHeight : 0);		
			}
		}
		
		public function determined(e:TournamentEvent) : void {
			won = left == e.left;
			invalidateDisplayList();
		}
	}
}