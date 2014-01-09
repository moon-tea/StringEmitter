package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Killer extends Sprite {
		public var Angle:Number = 0;		
		public var range:Number = 50;
		public var xspeed:Number = 1;		
		public var yspeed:Number = .05;
		public var centerX:Number = 100;
		public var centerY:Number = 100;		
		public var ratio:Number = .2;
		
		public function Killer() 
		{		
		init();
		}
		
		public function init():void {			
			graphicFill();			
		}
		
		public function graphicFill():void {
			//Make Killer								
			graphics.lineStyle(1, 0, 1);
			graphics.beginFill(0xff0000);
			graphics.moveTo(0 * ratio,0 * ratio);
			graphics.lineTo(75 * ratio,50 * ratio);
			graphics.lineTo(100 * ratio,0 * ratio);
			graphics.lineTo(125 * ratio,50 * ratio);
			graphics.lineTo(200 * ratio,0 * ratio);
			graphics.lineTo(150 * ratio,75 * ratio);
			graphics.lineTo(200 * ratio,100 * ratio);
			graphics.lineTo(150 * ratio,125 * ratio);
			graphics.lineTo(200 * ratio,200 * ratio);
			graphics.lineTo(125 * ratio,150 * ratio);
			graphics.lineTo(100 * ratio,200 * ratio);
			graphics.lineTo(75 * ratio,150 * ratio);
			graphics.lineTo(0 * ratio,200 * ratio);
			graphics.lineTo(50 * ratio,125 * ratio);
			graphics.lineTo(0 * ratio,100 * ratio);
			graphics.lineTo(50 * ratio,75 * ratio);
			graphics.moveTo(0 * ratio, 0 * ratio);
			graphics.endFill();			
		}		
		
	}
}