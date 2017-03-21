package mychart{
	import flash.display.Sprite;
	public class Scatter extends Sprite {
		public var radius:Number;
		private var colour:uint;
		public function Scatter(colour:uint=0xFF0000,radius:Number=3) {
			this.radius=radius;
			this.color=colour;this.colour=colour;
		}
		public function set color(value:uint) {
			this.graphics.lineStyle(1,value);
			this.graphics.beginFill(value,.7);
			this.graphics.drawCircle(0,0,radius);
			this.graphics.endFill();
		}
		public function get color() {
			return colour;
		}
	}
}