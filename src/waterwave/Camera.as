package waterwave{
	import flash.geom.Point;
	public class Camera {
		public static const Y_CORRECT:Number=Math.cos(- Math.PI/6)*Math.SQRT2;
		private var pos:Point3D;
		private var euler:Point3D;
		private var len:Number;
		private var transform:Vector.<Number>=new Vector.<Number>(8);
		public function Camera(pos:Point3D,di:Point3D,D:Number) {
			this.pos=pos;
			this.euler=di;
			this.len=D;
			transform[0]=c(euler.z)*c(euler.x)-s(euler.z)*c(euler.y)*s(euler.x);
			transform[1]=c(euler.z)*s(euler.x)+s(euler.z)*c(euler.y)*c(euler.x);
			transform[2]=s(euler.z)*s(euler.y);
			transform[3]=- s(euler.z)*c(euler.x)-c(euler.z)*c(euler.y)*s(euler.x);
			transform[4]=- s(euler.z)*s(euler.x)+c(euler.z)*c(euler.y)*c(euler.x);
			transform[5]=c(euler.z)*s(euler.y);
			transform[6]=s(euler.y)*s(euler.x);
			transform[7]=- s(euler.y)*c(euler.x);
			transform[8]=c(euler.y);
		}
		public function ToView(pos1:Point3D):Point {
			var pos2:Point3D=new Point3D  ;
			pos2.x=pos1.x-this.pos.x;//相对坐标
			pos2.y=pos1.y-this.pos.y;
			pos2.z=pos1.z-this.pos.z;
			var pos3:Point3D=new Point3D  ;
			pos3.x=transform[0]*pos2.x+transform[1]*pos2.y+transform[2]*pos2.z;//固有坐标
			pos3.y=transform[3]*pos2.x+transform[4]*pos2.y+transform[5]*pos2.z;
			pos3.z=transform[6]*pos2.x+transform[7]*pos2.y+transform[8]*pos2.z;
			return new Point(-pos3.x*len/pos3.z,-pos3.y*len/pos3.z);
		}
		private function s(a:Number):Number {
			return Math.sin(a);
		}
		private function c(a:Number):Number {
			return Math.cos(a);
		}
	}
}