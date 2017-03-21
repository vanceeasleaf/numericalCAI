package waterwave
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class Test extends Sprite
	{
		var camera:Camera;
		var cavas:Sprite;
		var graph:Sprite;
		// Parameters
		var n:int = 38;// grid size
		var g:Number = 30;// gravitational constant
		var dt:Number = 0.04;// hardwired timestep
		var dx:Number = 0.7;
		var dy:Number = .7;
		var ratiox:Number;
		var ratioy:Number;
		var nplotstep:int = 2;// plot interval
		var ndrops:int = 2;// maximum number of drops
		var nstep:int;
		var ndrop:int;
		var dropstep:int = 200;// drop interval
		var C:Vector2D=new Vector2D(n+1,n+1);
		var D:Vector2D;
		var H:Vector2D=new Vector2D(n+2,n+2);
		var U:Vector2D=new Vector2D(n+2,n+2);
		var V:Vector2D=new Vector2D(n+2,n+2);
		var Hx:Vector2D=new Vector2D(n+1,n+1);
		var Ux:Vector2D=new Vector2D(n+1,n+1);
		var Vx:Vector2D=new Vector2D(n+1,n+1);
		var Hy:Vector2D=new Vector2D(n+1,n+1);
		var Uy:Vector2D=new Vector2D(n+1,n+1);
		var Vy:Vector2D=new Vector2D(n+1,n+1);
		var i:int;
		var j:int;
		public function Test()
		{
			init();
		}
		function init()
		{
			ratiox = dt / dx;
			ratioy = dt / dy;
			cavas=new Sprite();
			var capos:Point3D = new Point3D(3500,5000,1500);
			var cadirec:Point3D=new Point3D(-Math.atan(35/50), Math.PI-Math.atan(6103.28/1500),0);
			camera = new Camera(capos,cadirec,4000);
			var p0:Point3D = new Point3D(0,0,0);
			var p1:Point3D = new Point3D(-600,0,0);
			var p2:Point3D = new Point3D(0,-600,0);
			var p5:Point3D = new Point3D(0,-600,240);
			var sp0:Point = camera.ToView(p0);
			var sp1:Point = camera.ToView(p1);
			var sp2:Point = camera.ToView(p2);
			var sp5:Point = camera.ToView(p5);
			cavas.x = 230;
			cavas.y = 300;
			addChild(cavas);
			cavas.graphics.lineStyle(0);
			cavas.graphics.moveTo(sp1.x,sp1.y);
			cavas.graphics.lineTo(sp0.x,sp0.y);
			cavas.graphics.lineTo(sp2.x,sp2.y);
			cavas.graphics.lineTo(sp5.x,sp5.y);
			var x1:Point3D;
			var x01:Point;
			var x2:Point3D;
			var x02:Point;
			var a:TextField;
			var num:Number;
			for (var i:int=0; i<=5; i++)
			{
				x1 = new Point3D(-120 * i,0,0);
				x01 = camera.ToView(x1);
				x2 = new Point3D(-120 * i,20,0);
				x02 = camera.ToView(x2);
				cavas.graphics.moveTo(x01.x,x01.y);
				cavas.graphics.lineTo(x02.x,x02.y);
				a = new TextField  ;
				a.x = x02.x;
				a.y = x02.y;
				num = i * 0.2;
				a.text = "" + num.toFixed(1);
				cavas.addChild(a);
			}
			for (i=0; i<=5; i++)
			{
				x1 = new Point3D(0,-120 * i,0);
				x01 = camera.ToView(x1);
				x2 = new Point3D(15,-120 * i,0);
				x02 = camera.ToView(x2);
				cavas.graphics.moveTo(x01.x,x01.y);
				cavas.graphics.lineTo(x02.x,x02.y);
				a = new TextField  ;
				a.x = x02.x - 20;
				a.y = x02.y - 5;
				num = i * 0.2;
				a.text = "" + num.toFixed(1);
				cavas.addChild(a);
			}
			for (i=0; i<=4; i++)
			{
				x1 = new Point3D(0,-600,60 * i);
				x01 = camera.ToView(x1);
				x2 = new Point3D(0,-15 - 600,60 * i);
				x02 = camera.ToView(x2);
				cavas.graphics.moveTo(x01.x,x01.y);
				cavas.graphics.lineTo(x02.x,x02.y);
				a = new TextField  ;
				a.x = x02.x - 24;
				a.y = x02.y - 12;
				num = i * 0.2 - 3;
				a.text = "" + num.toFixed(1);
				cavas.addChild(a);
			}
			waterwave();
		}
		function waterwave():void
		{
			D = droplet(1.5,13);// simulate a water drop
			// Initialize graphics
			initgraphics(n);
			for (var i:int=1; i<=n+2; i++)
			{
				for (var j:int=1; j<=n+2; j++)
				{
					H.v[i][j] = 1;
					U.v[i][j] = 0;
					V.v[i][j] = 0;
				}
			}
			for (i=1; i<=n+1; i++)
			{
				for (j=1; j<=n+1; j++)
				{
					Hx.v[i][j] = 0;
					Ux.v[i][j] = 0;
					Vx.v[i][j] = 0;
					Hy.v[i][j] = 0;
					Uy.v[i][j] = 0;
					Vy.v[i][j] = 0;
				}
			}

			initstart();

			//stop1.addEventListener(MouseEvent.CLICK,onstop);
			//start.addEventListener(MouseEvent.CLICK,restart);
			addEventListener(Event.UNLOAD,remove);
		}
		public function remove(e:Event):void
		{trace(111)
		removeEventListener(Event.ENTER_FRAME,drawgraph);
			camera=null;
			cavas = null;
			graph = null;
			C = null;
			D = null;
			H = null;
			U = null;
			V = null;
			Hx = null;
			Ux = null;
			Vx = null;
			Hy = null;
			Uy = null;
			Vy = null;
			removeEventListener(Event.UNLOAD,remove);

		}
		public function onstop(e:Event)
		{

			removeEventListener(Event.ENTER_FRAME,drawgraph);
		}
		public function restart(e:Event)
		{
			initstart();
		}
		function initstart()
		{
			addEventListener(Event.ENTER_FRAME,drawgraph);
			for (var i:int=1; i<=n+2; i++)
			{
				for (var j:int=1; j<=n+2; j++)
				{
					H.v[i][j] = 1;
					U.v[i][j] = 0;
					V.v[i][j] = 0;
				}
			}
			for (i=1; i<=n+1; i++)
			{
				for (j=1; j<=n+1; j++)
				{
					Hx.v[i][j] = 0;
					Ux.v[i][j] = 0;
					Vx.v[i][j] = 0;
					Hy.v[i][j] = 0;
					Uy.v[i][j] = 0;
					Vy.v[i][j] = 0;
				}
			}
			ndrop = int(Math.random() * ndrops) + 2;
			nstep = 0;
		}
		function drawgraph(e:Event)
		{
			nstep = nstep + 1;
			// Random water drops
			if ( nstep==10||nstep%dropstep == 0 && nstep <= ndrop*dropstep)
			{
				var w:int = D.v.length - 1;
				var rand:Number=int(Math.random()*(n-w-15))+1+15;
				var ran = Math.random() * .5 + .5;
				for (i=rand+1; i<=rand+w; i++)
				{
					for (j=rand+1; j<=rand+w; j++)
					{
						H.v[i][j] = H.v[i][j] + ran * D.v[i - rand][j - rand];
					}
				}
			}
			// Reflective boundary conditions
			for (i=1; i<=n+2; i++)
			{
				H.v[i][1] = H.v[i][2];
				U.v[i][1] = U.v[i][2];
				V.v[i][1] =  -  V.v[i][2];
				H.v[i][n + 2] = H.v[i][n + 1];
				U.v[i][n + 2] = U.v[i][n + 1];
				V.v[i][n + 2] =  -  V.v[i][n + 1];
				H.v[1][i] = H.v[2][i];
				U.v[1][i] =  -  U.v[2][i];
				V.v[1][i] = V.v[2][i];
				H.v[n + 2][i] = H.v[n + 1][i];
				U.v[n + 2][i] =  -  U.v[n + 1][i];
				V.v[n + 2][i] = V.v[n + 1][i];
			}
			// First half step
			// x direction

			for (j = 1; j<=n; j++)
			{
				for (i = 1; i<=n+1; i++)
				{
					// height
					Hx.v[i][j] = (H.v[i+1][j+1]+H.v[i][j+1])*.5 - ratiox*.5*(U.v[i+1][j+1]-U.v[i][j+1]);
					// x momentum
					Ux.v[i][j] = (U.v[i+1][j+1]+U.v[i][j+1])*.5 - ratiox*.5*((U.v[i+1][j+1]*U.v[i+1][j+1]/H.v[i+1][j+1] + g*.5*H.v[i+1][j+1]*H.v[i+1][j+1]) -  (U.v[i][j+1]*U.v[i][j+1]/H.v[i][j+1] + g*.5*H.v[i][j+1]*H.v[i][j+1]));
					// y momentum
					Vx.v[i][j] = (V.v[i+1][j+1]+V.v[i][j+1])*.5 - ratiox*.5*((U.v[i+1][j+1]*V.v[i+1][j+1]/H.v[i+1][j+1]) -  (U.v[i][j+1]*V.v[i][j+1]/H.v[i][j+1]));
				}
			}
			// y direction

			for (j = 1; j<=n+1; j++)
			{
				for (i = 1; i<=n; i++)
				{
					// height
					Hy.v[i][j] = (H.v[i+1][j+1]+H.v[i+1][j])*.5 - ratioy*.5*(V.v[i+1][j+1]-V.v[i+1][j]);
					// x momentum
					Uy.v[i][j] = (U.v[i+1][j+1]+U.v[i+1][j])*.5 - ratioy*.5*((V.v[i+1][j+1]*U.v[i+1][j+1]/H.v[i+1][j+1])- (V.v[i+1][j]*U.v[i+1][j]/H.v[i+1][j]));
					// y momentum
					Vy.v[i][j] = (V.v[i+1][j+1]+V.v[i+1][j])*.5 - ratioy*.5*((V.v[i+1][j+1]*V.v[i+1][j+1]/H.v[i+1][j+1] + g*.5*H.v[i+1][j+1]*H.v[i+1][j+1]) - (V.v[i+1][j]*V.v[i+1][j]/H.v[i+1][j] + g*.5*H.v[i+1][j]*H.v[i+1][j]));
				}
			}
			// Second half step

			for (j = 2; j<=n+1; j++)
			{
				for (i = 2; i<=n+1; i++)
				{
					// height
					H.v[i][j] = H.v[i][j] - (ratiox)*(Ux.v[i][j-1]-Ux.v[i-1][j-1]) -  (ratiox)*(Vy.v[i-1][j]-Vy.v[i-1][j-1]);
					// x momentum
					U.v[i][j] = U.v[i][j] -(ratiox)*((Ux.v[i][j-1]*Ux.v[i][j-1]/Hx.v[i][j-1] + g*.5*Hx.v[i][j-1]*Hx.v[i][j-1]) -(Ux.v[i-1][j-1]*Ux.v[i-1][j-1]/Hx.v[i-1][j-1] + g*.5*Hx.v[i-1][j-1]*Hx.v[i-1][j-1])) - (ratioy)*((Vy.v[i-1][j]*Uy.v[i-1][j]/Hy.v[i-1][j]) -  (Vy.v[i-1][j-1]*Uy.v[i-1][j-1]/Hy.v[i-1][j-1]));
					// y momentum
					V.v[i][j] = V.v[i][j] -(ratiox)*((Ux.v[i][j-1]*Vx.v[i][j-1]/Hx.v[i][j-1]) -(Ux.v[i-1][j-1]*Vx.v[i-1][j-1]/Hx.v[i-1][j-1])) - (ratiox)*((Vy.v[i-1][j]*Vy.v[i-1][j]/Hy.v[i-1][j] + g*.5*Hy.v[i-1][j]*Hy.v[i-1][j]) - (Vy.v[i-1][j-1]*Vy.v[i-1][j-1]/Hy.v[i-1][j-1] + g/2*Hy.v[i-1][j-1]*Hy.v[i-1][j-1]));
				}
			}
			// Update plot
			if (nstep%nplotstep == 0)
			{
				surf(H);
			}
		}

		function droplet(height:Number,width:Number):Vector2D
		{
			//DROPLET  2D Gaussian
			var x:Vector.<Number>=new Vector.<Number>(width+1);
			var i:int;
			var j:int;
			for (i=1; i<=width; i++)
			{
				x[i] = -1 + 2 / (width - 1) * (i - 1);
			}
			var D:Vector2D = new Vector2D(width,width);
			for (i=1; i<=width; i++)
			{
				for (j=1; j<=width; j++)
				{
					D.v[i][j] = height*Math.exp(-5*(x[i]*x[i]+x[j]*x[j]));
				}
			}
			return D;
		}
		function initgraphics(n:int)
		{
			graph = new Sprite  ;
			cavas.addChild(graph);
			graph.graphics.lineStyle(0);
			var x:Vector.<Number>=new Vector.<Number> (n+1);
			var p=new Vector.<Vector.<Point3D>>(n+1);
			var u=new Vector.<Vector.<Point>> (n+1);
			for (var i=1; i<=n; i++)
			{
				x[i] = (i - 1) / (n - 1);
			}
			for (i=1; i<=n; i++)
			{
				p[i]=new Vector.<Point3D> (n+1) ;
				u[i]=new Vector.<Point>(n+1)  ;
				for (var j=1; j<=n; j++)
				{
					p[i][j] = new Point3D(-600 * x[i],-600 * x[j],60);
					u[i][j] = camera.ToView(p[i][j]);
				}
			}
			for (i=n-1; i>1; i--)
			{
				for (j=n; j>1; j--)
				{
					graph.graphics.beginFill(0x00ffff,0.7);
					M(graph,u[i][j]);
					L(graph,u[i-1][j]);
					L(graph,u[i-1][j-1]);
					L(graph,u[i][j-1]);
					L(graph,u[i][j]);
					graph.graphics.endFill();
				}
			}
		}
		function M(g:Sprite,u:Point )
		{
			g.graphics.moveTo(u.x,u.y);
		}
		function L(g:Sprite,u:Point)
		{
			g.graphics.lineTo(u.x,u.y);
		}
		function surf(z:Vector2D)
		{
			var x:Vector.<Number>=new Vector.<Number>(n+1);
			for (var i=1; i<=n; i++)
			{
				x[i] = (i - 1) / (n - 1);
			}
			var p=new Vector.<Vector.<Point3D>>(n+1);
			var u=new Vector.<Vector.<Point>> (n+1);
			for (i=1; i<=n; i++)
			{
				p[i]=new Vector.<Point3D> (n+1) ;
				u[i]=new Vector.<Point>(n+1)  ;
				for (var j=1; j<=n; j++)
				{
					p[i][j] = new Point3D(-600 * x[i],-600 * x[j],60 * z.v[i + 1][j + 1]);
					u[i][j] = camera.ToView(p[i][j]);
				}
			}
			graph.graphics.clear();
			graph.graphics.lineStyle(0);

			for (j=n; j>=2; j--)
			{
				for (i=n-1; i>=2; i--)
				{
					graph.graphics.beginFill(0x00ffff,0.7);
					M(graph,u[i][j]);
					L(graph,u[i-1][j]);
					L(graph,u[i-1][j-1]);
					L(graph,u[i][j-1]);
					L(graph,u[i][j]);
					graph.graphics.endFill();
				}
			}
		}
		function isnan(H:Vector2D):Boolean
		{
			var n = H.v.length;
			for (var i=1; i<=n; i++)
			{
				for (var j=1; j<=n; j++)
				{
					if (isNaN(H.v[i][j]))
					{
						return true;
						break;
					}
				}
			}
			return false;
		}
	}
}
class Vector2D {;
public var v:Vector.<Vector.<Number >  > ;
public function Vector2D(n:int,m:int)
{
	v=new Vector.< Vector.<Number>>(n+1);
	v[0] = null;
	for (var i=1; i<=n; i++)
	{
		v[i]=new Vector.<Number>(m+1);
		v[i][0] = null;
	}
}
}