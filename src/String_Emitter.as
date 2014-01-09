package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class String_Emitter extends Sprite {
		public var dx:Number = 0;
		public var dy:Number = 0;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var ax:Number = 0;
		public var ay:Number = 0;
		public var angle:Number = 0;
		public var radius:Number = 26;
		
		public function String_Emitter() 
		{		
		init();
		}
		public function init():void {			
			graphicFill();			
		}
		public function graphicFill():void {
			//Make Arrow
			graphics.beginFill(0x00ff00);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			graphics.lineStyle(1, 0, 1);
			graphics.beginFill(0xffff00);
			graphics.moveTo(-25, -12.5);
			graphics.lineTo(0, -12.5);
			graphics.lineTo(0, -25);
			graphics.lineTo(25, 0);
			graphics.lineTo(0, 25);
			graphics.lineTo(0, 12.5);
			graphics.lineTo(-25, 12.5);
			graphics.lineTo(-25, -12.5);
			graphics.endFill();
			
		}		
		
	}
}