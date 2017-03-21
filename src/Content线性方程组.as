package 
{
	import gauseslim.ValishCollumn;
	import lu.LUdisorb;
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.text.TextFormat;

	public class Content线性方程组 extends MovieClip
	{
		private var timer:int;
		private var time:int;
		var methodNumber:String = "1";
		function get precision():int
		{
			return parseInt(Input_精度要求.text);
		}
		function get 演示间隔():Number
		{
			return parseFloat(Input_演示间隔.text);
		}
		private var diedaiEnd:Boolean = false;
		var res:Array = [];//方程解
		var res2:Array = [];//保存上一阶方程解
		private var coefficients:Array = [];
		private var iOrder:int;//方程的阶
		private var xPositions:Array = [];//label的位置
		private var yPositions:Array = [];
		private var labels:Array = [];
		private var collumnWidths:Array = [];//每列的格宽
		private var collumnXs:Array = [];//每个格子的位置
		private var collumnYs:Array = [];
		private var allWidth:Number;//总宽
		private var allHeight:Number;
		private var valishc:ValishCollumn;//列主元消去法
		private var lu1:LUdisorb;
		public function Content线性方程组()
		{

			frame.visible = true;
			text.visible = false;
			var tf:TextFormat = new TextFormat  ;
			tf.size = 30;
			tf.align = "center";
			text.setStyle("textFormat",tf);
			coef.Input_coef.setStyle("textFormat",tf);
			var tf1:TextFormat = new TextFormat  ;
			tf1.align = "center";
			tf1.size = 20;
			results.Output.setStyle("textFormat",tf1);
			for each (var button:String in ["自动","下一步","上一步","暂停","结果","帮助","复位","系数矩阵"])
			{
				this[button].addEventListener(MouseEvent.CLICK,onClick);
			}
			for each (button in ["确定","矩阵1","矩阵2","矩阵3","矩阵4"])
			{
				coef[button].addEventListener(MouseEvent.CLICK,onClick);
			}
			method.addEventListener(Event.CHANGE ,onMethod);
			for each (var textField:TextField in [Input_精度要求,Input_演示间隔])
			{
				new InputChange(textField,reset);
			}
			coef.Input_coef.text = "10,-2,-2,1\n" + "-2,10,-1,0.5\n" + "-1,-2,3,1";
			//"6,2,1,-1,6\n"+
			//"1,1,4,-1,5\n"+
			//"2,4,1,0,-1\n"+
			// "-1,0,-1,3,-5";
			time = 0;
		}
		function setMatrix()
		{
			coefficients = [];
			var text:String = coef.Input_coef.text;
			var coefString:Array = text.split(String.fromCharCode(13));
			var k:int = 0;
			for each (var row:String in coefString)
			{
				if (row=='')
				{
					continue;
				}
				var items:Array = row.split(",");
				var a:Array = [];
				for (var i in items)
				{
					a[i] = parseFloat(items[i]);
				}
				coefficients[k] = a;
				k++;
			}
			iOrder = coefficients.length;
			setFrame();
			valishc = new ValishCollumn(coefficients,labels);//列主元消去
			lu1 = new LUdisorb(coefficients,labels);//LU分解
			showResult();
		}
		function onMethod(e:Event )
		{
			methodNumber = method.value;
			if (methodNumber.match(/1|2/))
			{
				text.visible = false;
				frame.visible = true;
			}
			else
			{
				text.visible = true;
				frame.visible = false;
			}
			reset();
		}
		function next()
		{
			switch (methodNumber)
			{
				case "1" :
					valishc.next();
					break;
				case "2" :
					lu1.next();
					break;
				default :
					diedai();
			}
			time++;
		}
		function get calculateEnd():Boolean
		{
			switch (methodNumber)
			{
				case "1" :
					return !valishc.commands.hasNextCommands;
					break;
				case "2" :
					return !lu1.commands.hasNextCommands;
					break;
				default :
					return diedaiEnd;
			}
		}
		function previous()
		{
			switch (methodNumber)
			{
				case "1" :
					valishc.previous();
					break;
				case "2" :
					lu1.previous();
			}
		}
		function onClick(e:MouseEvent )
		{
			switch (e.currentTarget .name)
			{
				case "自动" :
					reset();
					timedCount();
					break;
				case "下一步" :
					next();
					break;
				case "上一步" :
					previous();
					break;
				case "暂停" :
					clearTimeout(timer);
					break;
				case "结果" :
					e.stopImmediatePropagation();
					results.visible = ! results.visible;

					break;
				case "帮助" :
					break;
				case "复位" :
					reset();
					break;
			
				case "确定" :
					setMatrix();
					break;
				case "系数矩阵" :
					coef.visible = true;
					break;
				case "矩阵1" :
					coef.Input_coef.text=
					"6,2,1,-1,6\n"+"2,4,1,0,-1\n"+
					"1,1,4,-1,5\n"+
					 "-1,0,-1,3,-5";// "10,-2,-2,1\n"+"-2,10,-1,0.5\n"+"-1,-2,3,1"
					setMatrix();
					break;
				case "矩阵2" :
					coef.Input_coef.text= 
					"3.5,9.3,1,0,1.6,3.8\n"+
					"6,2,1,-1,6,12.4\n"+
					"12.3,5.3,7.8,-3,2,9.7\n"+
					"7.5,1,4,-1,5,6.4\n"+
					 "-1,0,9.8,3,-5,7.8";
					setMatrix();
					break;
				case "矩阵3" :
					coef.Input_coef.text = "7,2,1,-2,4\n" + "9,15,3,-2,7\n" + "-2,-2,11,5,-1\n" + "1,3,2,13,0\n";
					setMatrix();
					break;
				case "矩阵4" :
					coef.Input_coef.text= 
					"2.3,3.5,9.3,1,0,1.6,3.8\n"+
					"8.5,6,2,1,-1,6,12.4\n"+
					"7,12.3,5.3,7.8,-3,2,9.7\n"+
					"9.2,7.5,1,4,-1,5,6.4\n"+
					"3.7,6.5,17.3,12.5,2,2.4,3.8\n"+
					 "13.8-1,0,9.8,3,-5,7.8,1.2";
					setMatrix();
					break;
			}
		}

		function diedai()
		{
			if (time==0)
			{
				var methdName:String;
				switch (methodNumber)
				{
					case "3" :
						methdName = "高斯雅可比迭代法";
						break;
					case "4" :
						methdName = "高斯赛德尔迭代法";
						break;
					case "5" :
						methdName = "超松弛迭代法";
						break;
					default :
						methdName = "";
				}
				text.htmlText +=  methdName;
				text.htmlText +=  "<p>开始迭代</p>";
				text.htmlText +=  "<p>迭代初值为</p>";
				for (var i:int=0; i<iOrder; i++)
				{
					res2[i] = 0;
					var p:int = i + 1;
					text.htmlText +=  "<p>x" + p + "=" + floor(res2[i],precision) + "</p>";
				}
				text.htmlText +=  "\n";
				text.verticalScrollPosition = text.maxVerticalScrollPosition;
			}
			else
			{
				if (! diedaiEnd)
				{
					for (i= 0; i < iOrder; ++i)
					{
						var dSum2:Number = 0;
						for (var j:int  = 0; j < iOrder; j++)
						{//求第二项
							if ( j == i )
							{
								continue;
							}
							var r:Number;
							if (methodNumber=="3")
							{//jacobi
								r = res2[j];
							}
							else
							{
								r = i < j ? res2[j]:res[j];//sidel
							}
							dSum2 +=  coefficients[i][j] * r;
						}
						res[i] = 1/coefficients[i][i] * ( coefficients[i][iOrder] - dSum2 );
						if (methodNumber=="5")
						{//sor
							var w:Number = 1.5;
							res[i] = res[i] * w + (1 - w) * res2[i];
						}
					}

					var a:Boolean = true;
					for (i= 0; i < iOrder; ++i)
					{
						a = a && Math.abs(res2[i] - res[i]) < Math.pow(10, -  precision);//解的每个分量都满足精度
					}
					text.htmlText +=  "<p>迭代次数" + time + "</p>";
					if (a)
					{
						diedaiEnd = true;
						text.htmlText +=  "<p>得到满足要求的解</p>";
					}

					for (i=0; i<iOrder; i++)
					{
						p = i + 1;
						text.htmlText +=  "<p>x" + p + "=" + floor(res[i],precision) + "</p>";
					}
					text.htmlText +=  "\n";
					text.verticalScrollPosition = text.maxVerticalScrollPosition;
					for (i = 0; i < iOrder; i++)
					{
						res2[i] = res[i];
					}
				}
			}
		}
		function showResult()
		{
			results.Output.htmlText = "";
			var i:int;
			var A:Array = [];
			var B:Array = [];
			for (i=0; i<iOrder; i++)
			{
				A[i] = coefficients[i].slice(0,iOrder);
				B[i] = coefficients[i][iOrder];
			}
			var x:Array = [];
			x = gauss(A,B);
			for (i=0; i<iOrder; i++)
			{
				results.Output.htmlText +=  "<p>x" + (i + 1) + "=" + floor(x[i],precision) + "</p>";
			}
		}
		function gauss(a:Array ,b:Array ):Array
		{
			var n:int = b.length;
			var A:Array = [];
			for (i=0; i<n; i++)
			{
				A[i] = [];
				A[i] = a[i].concat();
				A[i][n] = b[i];
			}
			for (var k:int=0; k<n; k++)
			{
				var Amax = 0.0;
				var Imax:int = 0;
				for (var i:int=k; i<n; i++)
				{
					if (Math.abs(A[i][k]) > Amax)
					{
						Amax = Math.abs(A[i][k]);
						Imax = i;
					}
				}
				if (Math.abs(Amax) < 1.0e-32)
				{
					trace(''+k+' '+k+' '+Amax);
					A[Imax][k] = 1.0;
				}


				for (var j:int=k; j<n+1; j++)
				{//交换
					var T = A[k][j];
					A[k][j] = A[Imax][j];
					A[Imax][j] = T;
				}
				Amax = A[k][k];
				for (j=k; j<n+1; j++)
				{//归一
					A[k][j] = A[k][j] / Amax;
				}
				for (i=k+1; i<n; i++)
				{//消去
					for (j=n; j>=k; j--)
					{
						A[i][j] -=  A[i][k] * A[k][j];
					}
				}
			}
			for (k=n-1; k>0; k--)
			{//回代
				T = A[k][n];
				for (i=k-1; i>=0; i--)
				{
					A[i][n] -=  T * A[i][k];

				}
			}
			var c:Array = [];
			for (i=0; i<n; i++)
			{
				c[i] = A[i][n];
			}
			return c;
		}
		function floor(number:Number,n:uint):Number
		{
			var a:Number = Math.pow(10,n);
			if (number<0)
			{
				return int(number*a-.5)/a;
			}
			else
			{
				return int(number*a+.5)/a;
			}
		}
		function reset()
		{
			if (! isNaN(timer))
			{
				clearTimeout(timer);
			}
			time = 0;
			text.htmlText = "";
			setMatrix();
			diedaiEnd = false;
		}
		function timedCount()
		{
			next();
			if (! calculateEnd)
			{
				timer = setTimeout(function(){timedCount()},演示间隔 * 1000);
			}
		}
		function setFrame()
		{//将矩阵画出来
			while (frame.numChildren>0)
			{
				frame.removeChildAt(0);
			}
			labels = [];
			xPositions = [];
			collumnWidths = [];
			collumnXs = [];
			yPositions = [];
			var i:int;
			var j:int;
			for (i=0; i<iOrder; i++)
			{//产生textFields
				labels[i] = [];
				xPositions[i] = [];
				for (j=0; j<iOrder +1; j++)
				{
					var la:TextField = new TextField  ;
					labels[i][j] = la;
					la.text = "" + floor(coefficients[i][j],2);
					la.autoSize = "center";
					la.selectable = false;
					frame.addChild(la);
				}
			}
			var gap:int = 20;
			for (j=0; j<iOrder +1; j++)
			{//计算列宽
				var collumnWidth:Number = labels[0][j].textWidth + gap;
				for (i=1; i<iOrder; i++)
				{
					collumnWidth = collumnWidth < labels[i][j].textWidth + gap ? labels[i][j].textWidth + gap:collumnWidth;
				}
				collumnWidths[j] = collumnWidth;
			}
			collumnXs[0] = 0;
			for (j=1; j<collumnWidths.length; j++)
			{
				collumnXs[j] = collumnXs[j - 1] + collumnWidths[j - 1];
			}
			allWidth = collumnXs[collumnXs.length - 1] + collumnWidths[collumnWidths.length - 1];
			allHeight=(labels[0][0].textHeight+2)*labels.length;
			for (i=0; i<labels.length; i++)
			{
				yPositions[i]=(labels[0][0].textHeight+2)*i-allHeight*.5;
			}
			for (i=0; i<iOrder; i++)
			{
				for (j=0; j<iOrder +1; j++)
				{
					xPositions[i][j]=collumnXs[j]+(collumnWidths[j]-labels[i][j].textWidth)*.5-allWidth*.5;
					labels[i][j].x = xPositions[i][j];
					labels[i][j].y = yPositions[i];
				}
			}
			frame.scaleY = frame.scaleX = standard.width / allWidth;
		}

	}
}