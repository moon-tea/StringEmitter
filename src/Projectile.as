package {
	import flash.display.Sprite;
	
	public class Projectile extends Sprite {
		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
				
		public function Projectile(radius:Number=5, color:uint=0xff0000) {
			this.radius = radius;
			this.color = color;
			init();
		}
		public function init():void {
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
	}
}