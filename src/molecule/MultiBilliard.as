package molecule
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	public class MultiBilliard extends Sprite
	{
		private var balls:Array;
		private var maxRadius:int = 5;
		private var numBalls:uint = 150;
		private var bounce:Number = -1;

		public function MultiBilliard()
		{
			this.init();
			return;
		}// end function
public function dispose(){
	removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
	balls=null
}
		function checkWalls(param1:Ball)
		{
			if (param1.x < param1.radius)
			{
				param1.x = param1.radius;
				param1.vx = param1.vx * this.bounce;
			}
			else if (param1.x > frame.width - param1.radius)
			{
				param1.x = frame.width - param1.radius;
				param1.vx = param1.vx * this.bounce;
			}
			if (param1.y < param1.radius)
			{
				param1.y = param1.radius;
				param1.vy = param1.vy * this.bounce;
			}
			else if (param1.y > frame.height - param1.radius)
			{
				param1.y = frame.height - param1.radius;
				param1.vy = param1.vy * this.bounce;
			}
			return;
		}// end function

		private function rotate(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean):Point
		{
			var _loc_6:* = new Point();
			if (param5)
			{
				_loc_6.x = param1 * param4 + param2 * param3;
				_loc_6.y = param2 * param4 - param1 * param3;
			}
			else
			{
				_loc_6.x = param1 * param4 - param2 * param3;
				_loc_6.y = param2 * param4 + param1 * param3;
			}
			return _loc_6;
		}// end function

		private function init():void
		{
			var _loc_2:Number = NaN;
			var _loc_3:Ball = null;
			this.balls = [];
			var _loc_1:uint = 0;
			_loc_2 = 80;
			_loc_3 = new Ball(_loc_2,Math.random() * 16777215);//半径和颜色
			_loc_3.mass = 500;
			_loc_3.x = 200;
			_loc_3.y = 100;
			_loc_3.vx = Math.random() * 1 - .3;
			_loc_3.vy = Math.random() * 1 - .3;
			addChild(_loc_3);
			this.balls.push(_loc_3);
			_loc_1 = _loc_1 + 1;
			while (_loc_1 < this.numBalls)
			{

				_loc_2 = Math.random() * maxRadius + 5;
				_loc_3 = new Ball(_loc_2,Math.random() * 16777215);//半径和颜色
				_loc_3.mass = _loc_2;
				_loc_3.x = Math.random()*(frame.width) ;
				_loc_3.y =  Math.random()*(frame.height) ;
				_loc_3.vx = Math.random() * 10 - 5;
				_loc_3.vy = Math.random() * 10 - 5;
				addChild(_loc_3);
				this.balls.push(_loc_3);
				_loc_1 = _loc_1 + 1;
			}
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
			return;
		}// end function

		private function checkCollision(param1:Ball, param2:Ball):void
		{
			var _loc_6:Number = NaN;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_9:Point = null;
			var _loc_10:Point = null;
			var _loc_11:Point = null;
			var _loc_12:Point = null;
			var _loc_13:Number = NaN;
			var _loc_14:Number = NaN;
			var _loc_15:Number = NaN;
			var _loc_16:Object = null;
			var _loc_17:Object = null;
			var _loc_18:Object = null;
			var _loc_19:Object = null;
			var _loc_3:* = param2.x - param1.x;
			var _loc_4:* = param2.y - param1.y;
			var _loc_5:* = Math.sqrt(_loc_3 * _loc_3 + _loc_4 * _loc_4);
			if (Math.sqrt(_loc_3 * _loc_3 + _loc_4 * _loc_4) < param1.radius + param2.radius)
			{

				_loc_6 = Math.atan2(_loc_4,_loc_3);
				_loc_7 = Math.sin(_loc_6);
				_loc_8 = Math.cos(_loc_6);
				_loc_9 = new Point(0,0);
				_loc_10 = this.rotate(_loc_3,_loc_4,_loc_7,_loc_8,true);
				_loc_11 = this.rotate(param1.vx,param1.vy,_loc_7,_loc_8,true);
				_loc_12 = this.rotate(param2.vx,param2.vy,_loc_7,_loc_8,true);
				_loc_13 = _loc_11.x - _loc_12.x;
				_loc_11.x = ((param1.mass - param2.mass) * _loc_11.x + 2 * param2.mass * _loc_12.x) / (param1.mass + param2.mass);
				_loc_12.x = _loc_13 + _loc_11.x;
				_loc_14 = Math.abs(_loc_11.x) + Math.abs(_loc_12.x);
				_loc_15 = param1.radius + param2.radius - Math.abs(_loc_9.x - _loc_10.x);
				_loc_9.x = _loc_9.x + _loc_11.x / _loc_14 * _loc_15;
				_loc_10.x = _loc_10.x + _loc_12.x / _loc_14 * _loc_15;
				_loc_16 = this.rotate(_loc_9.x,_loc_9.y,_loc_7,_loc_8,false);
				_loc_17 = this.rotate(_loc_10.x,_loc_10.y,_loc_7,_loc_8,false);
				_loc_18 = this.rotate(_loc_11.x,_loc_11.y,_loc_7,_loc_8,false);
				_loc_19 = this.rotate(_loc_12.x,_loc_12.y,_loc_7,_loc_8,false);




				if (param1.mass > 300)
				{
					var u = Math.abs(_loc_18.x - param1.vx);
					var v = Math.abs(_loc_18.y - param1.vy);
					if (u>.1)
					{
						_loc_18.x = u > Math.abs(param1.vx) ? param1.vx:u;
						_loc_16.x = 0;
					}
					if (v>.1)
					{
						_loc_18.y = v > Math.abs(param1.vy) ? param1.vy:v;
						_loc_16.y = 0;
					}
				}
				param1.x = param1.x + _loc_16.x;
				param1.y = param1.y + _loc_16.y;
				param1.vx = _loc_18.x;
				param1.vy = _loc_18.y;
				param2.x = param1.x + _loc_17.x;
				param2.y = param1.y + _loc_17.y;
				param2.vx = _loc_19.x;
				param2.vy = _loc_19.y;
			}
			return;
		}// end function

		private function onEnterFrame(event:Event):void
		{
			var _loc_3:Ball = null;
			var _loc_4:Ball = null;
			var _loc_5:Number = NaN;
			var _loc_6:Ball = null;
			var _loc_2:uint = 0;
			while (_loc_2 < this.numBalls)
			{

				_loc_3 = this.balls[_loc_2];
				_loc_3.x = _loc_3.x + _loc_3.vx;
				_loc_3.y = _loc_3.y + _loc_3.vy;
				this.checkWalls(_loc_3);
				_loc_2 = _loc_2 + 1;
			}
			_loc_2 = 0;
			while (_loc_2 < (this.numBalls - 1))
			{

				_loc_4 = this.balls[_loc_2];
				_loc_5 = _loc_2 + 1;
				while (_loc_5 < this.numBalls)
				{

					_loc_6 = this.balls[_loc_5];
					this.checkCollision(_loc_4, _loc_6);
					_loc_5 = _loc_5 + 1;
				}
				_loc_2 = _loc_2 + 1;
			}
			return;
		}// end function

	}
}