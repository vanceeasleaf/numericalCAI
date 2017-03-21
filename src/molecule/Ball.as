package molecule
{
    import flash.display.*;

    public class Ball extends Sprite
    {
        public var vx:Number = 0;
        public var color:uint;
        public var isDragged:Object = false;
        public var vy:Number = 0;
        public var count:uint = 0;
        public var radius:uint;
        public var mass:Number = 1;
        public var vr:Number = 0;

        public function Ball(param1:Number = 50, param2:uint = 16711680)
        {
            this.radius = param1;
            this.color = param2;
            this.init();
            return;
        }// end function

        private function init() : void
        {
			graphics.lineStyle (1,this.color );
            graphics.beginFill(this.color,.7);
            graphics.drawCircle(0, 0, this.radius);
            graphics.endFill();
            return;
        }// end function

    }
}
