package {
	import flash.display.Sprite;
	
	public class Rect extends Sprite {		
		public var Width:Number;
		public var Height:Number;		
		private var color:uint;		
				
		public function Rect(Width:Number=100, Height:Number=100, color:uint=0x000000) {
			this.Width = Width;
			this.Height = Height;			
			this.color = color;
			init();
		}
		public function init():void		
		{
			graphicFill();		
		}
		public function graphicFill():void 
		{
			graphics.beginFill(color);
			graphics.drawRoundRect(0, 0, Width, Height, 10);
			graphics.endFill();
		}
	}
}