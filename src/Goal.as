package {
	import flash.display.Sprite;
	
	public class Goal extends Sprite {			
				
		public function Goal() {			
			init();
		}
		public function init():void 
		{
			graphics.lineStyle(3,0x00ff00);
			graphics.beginFill(0x00ffff);
			graphics.drawRoundRect(0, 0, 50, 50, 10);
			graphics.endFill();
		}
	}
}