package tournament
{
	import flash.events.MouseEvent;
	
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.controls.Label;
	import mx.core.UIComponent;

	public class TournamentRenderer extends Grid
	{
		public function TournamentRenderer()
		{
			super();
		}
		
		private var _tournament:Tournament;
		
		public function get tournament() : Tournament {
			return _tournament;
		}
		
		public function set tournament(t:Tournament) : void {
			_tournament = t;
			
			fillGrid();
		}
		
		private function fillGrid() : void {
			var nRows:int = _tournament.players.length * 2 - 1;
			var gridRows:Array = new Array();
			
			for(var i:int = 0; i < nRows; i++){
				gridRows.push(new GridRow());
			}
			
			fillGridImpl(_tournament, 1, gridRows);
			
			for each(var gridRow:GridRow in gridRows){
				addChild(gridRow);
			}
		}
		
		private function fillGridImpl(t:Tournament, roundDiff:int, gridRows:Array) : void {
			if(t.players.length == 1 && gridRows.length == 1){
				var player:Player = t.players[0] as Player;
				var gridRow:GridRow = gridRows[0] as GridRow;
				addToRow(gridRow, new TournamentHBar(t, false), 1, roundDiff);
				addToRow(gridRow, createLabel(player.id), 1, 1);
			}
			else{
				var i:int = centerIndexOf(t);
				var iL:int = centerIndexOf(t.left);
				var iR:int = i + 1 + centerIndexOf(t.right);
				
				addToRow(gridRows[0], new UIComponent(), iL, roundDiff);
				addToRow(gridRows[iL], new TournamentVBar(t, false, true), 1, roundDiff);
				addToRow(gridRows[iL+1], new TournamentVBar(t, true, true), i - iL - 1, roundDiff);
				addToRow(gridRows[i], new TournamentHBar(t, true), 1, roundDiff);
				addToRow(gridRows[i+1], new TournamentVBar(t, true, false), iR - i - 1, roundDiff);
				addToRow(gridRows[iR], new TournamentVBar(t, false, false), 1, roundDiff);
				addToRow(gridRows[iR+1], new UIComponent(), gridRows.length - iR - 1, roundDiff);

				fillGridImpl(t.left, t.round - t.left.round, gridRows.slice(0, i));
				fillGridImpl(t.right, t.round - t.right.round, gridRows.slice(i + 1, gridRows.length));
			}
		}
		
		private function addToRow(gridRow:GridRow, c:UIComponent, rowSpan:int, colSpan:int) : void {
			if(rowSpan > 0 && colSpan > 0){
				var gridItem:GridItem = new GridItem();
				c.width = 64 * colSpan;
				c.height = 24 * rowSpan;
				gridItem.addChild(c);
				gridItem.rowSpan = rowSpan;
				gridItem.colSpan = colSpan;
				gridRow.addChild(gridItem);
			}
		}
		
		private function centerIndexOf(t:Tournament) : int {
			return t.left ? t.left.players.length * 2 - 1: 0;
		}
		
		private function createLabel(s:String) : Label {
			var label:Label = new Label();
			label.text = s;
			label.addEventListener(MouseEvent.CLICK, labelClick);
			return label;
		}
		
		public function labelClick(e:MouseEvent) : void {
			_tournament.wonBy(new Player((e.currentTarget as Label).text));
		}
	}
}