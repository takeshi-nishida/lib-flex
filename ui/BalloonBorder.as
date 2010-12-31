package ui
{
	import mx.skins.Border;

	public class BalloonBorder extends Border
	{
		public function BalloonBorder()
		{
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			var d:int = getStyle("paddingLeft") - getStyle("paddingRight");
			var backgroundColor:int = getStyle("backgroundColor");
			var cornerRadius:int = getStyle("cornerRadius");
			
			graphics.beginFill(backgroundColor);
			graphics.drawRoundRect(d, 0, unscaledWidth - d, unscaledHeight, cornerRadius, cornerRadius);
//			graphics.moveTo(0, unscaledHeight / 2 + d / 2);
//			graphics.lineTo(d, unscaledHeight / 2 + d / 2);
//			graphics.lineTo(d, unscaledHeight / 2 - d / 2);
			graphics.moveTo(0, unscaledHeight / 2);
			graphics.lineTo(d, unscaledHeight / 2 + d / 2);
			graphics.lineTo(d, unscaledHeight / 2 - d / 2);
			graphics.endFill();
		}
	}
}