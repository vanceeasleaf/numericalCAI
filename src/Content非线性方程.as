package 
{

	import flash.display.Sprite;
	import mychart.*;
	import bkde.as3.parsers.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class Content非线性方程 extends Sprite
	{
		private var dataNumber:int = 201;
		var procFun:MathParser;
		var compObj1:CompiledObject;
		private var data:Array = [];
		private var timer:int;
		private var time:int;
		private var x1:Number;
		private var x0:Number;
		private var diedaiEnd:Boolean = false;
		var methodNumber:String = "1";
		var chart:Chart;
		public function Content非线性方程()
		{
			procFun = new MathParser(["x"]);
			compObj1 = procFun.doCompile(Input_func.text);
			var tf:TextFormat = new TextFormat  ;
			tf.size = 20;
			tf.align = "center";
			text.setStyle("textFormat",tf);
			drawori();
			var options:Object={
			renderTo:chartFrame,
			margin:[4,4,64,44],
			series:[
			{name:'原函数',type:'line',data:data,color:0x000FF0},
			{name:'x轴',type:'line',data:[[down,0],[up,0]],color:0xFF0000},
			{name:'null',type:'line',data:middle((up+down)/2),color:0x000FF0,alpha:0.4},
			{name:'null',type:'line',data:[],color:0x0FF000,alpha:0.4}
			]
			};
			chart = new Chart(options);
			for each (var textField:TextField in [精度,区间上限,区间下限])
			{
				new InputChange(textField,reset);
			}
			new InputChange(Input_func,funcReset);
			function funcReset()
			{
				compObj1 = procFun.doCompile(Input_func.text);
				reset();
			}
			for each (var buttonName:String in ["手动","自动","复位","暂停","返回"])
			{
				this[buttonName].addEventListener(MouseEvent.CLICK,onClick);
			}
			method.addEventListener(Event.CHANGE ,onMethod);
		}

		function get up():Number
		{
			return parseFloat(区间上限.text);
		}
		function get interval():Number
		{
			return (up-down)/(dataNumber-1);
		}
		function get down():Number
		{
			return parseFloat(区间下限.text);
		}
		function get precision():int
		{
			return parseInt(精度.text);
		}
		function middle(mid:Number )
		{
			return [[mid,0],[mid,ori(mid)]];
		}
		function onMethod(e:Event )
		{
			methodNumber = method.value;
			区间上限.text = "2";
			区间下限.text = "-3";
			reset();
		}
		function onClick(e:MouseEvent)
		{
			switch (e.currentTarget.name)
			{
				case "手动" :
					cal();
					time++;
					break;
				case "自动" :
					reset();
					timedCount();
					break;
				case "复位" :
					区间上限.text = "2";
					区间下限.text = "-3";
					reset();
					break;
				case "暂停" :
					clearTimeout(timer);
					break;
				case "返回" :
					dispatchEvent(new Event ("goBack"));
					break;
			}
		}
		function reset()
		{

			drawori();
			chart.series[0].setData(data,false);
			chart.series[1].setData([[down,0],[up,0]],false);
			chart.series[2].setData([],false);
			chart.series[3].setData([],false);
			chart.redraw();
			time = 0;
			diedaiEnd = false;
			clearTimeout(timer);
			text.htmlText = '';
		}
		function qiexian()
		{
			if (time==0)
			{
				x1 = down;
			}

			var x2:Number = x1;
			x1 = line(x1);
			if (x1<down)
			{
				区间上限.text = down.toString();//注意顺序
				区间下限.text = x1.toString();
			}
			if (x1>up)
			{
				区间下限.text = up.toString();
				区间上限.text = x1.toString();

			}
			else
			{
				if (x1<x2)
				{
					区间下限.text = x1.toString();
				}
				else
				{
					区间上限.text = x1.toString();
				}
			}
			drawori();
			chart.series[0].setData(data);
			chart.series[1].setData([[down,0],[up,0]]);
			chart.series[2].setData([[x2,ori(x2)],[x1,0]]);
			chart.series[3].setData([[x1,0],[x1,ori(x1)]]);
			chart.redraw();
		}
		function print(a:String )
		{
			text.htmlText +=  a;
			text.verticalScrollPosition = text.maxVerticalScrollPosition;
		}
		function cal()
		{
			if (diedaiEnd)
			{
				return;
			}var k:int
			switch (methodNumber)
			{
				case "1" :k=int(time/2)+1
					erfen();
					break;
				case "2" :k=time
					qiexian();
					break;
				case "3" :
					secant1();k=int(time/2)
					break;
				case "4" :
					secant2();k=time
					break;
			}
			var a:Number = parseFloat(区间下限.text);
			var b:Number = parseFloat(区间上限.text);
			
			print( "<p>迭代次数 =" + k + "</p>");
			print( "<p>根所在区间为\n[" + floor(a,precision+1) + "," + floor(b,precision+1) + "]</p>");
			if (Math.abs (a-b)<Math.pow(10,-precision))
			{
				print( "<p>达到指定精度</p>");

				diedaiEnd = true;
			}
		}
		function secant1()
		{
			if (time%2==0)
			{
				var x2:Number;
				x2 = up - ori(up) * (up - down) / (ori(up) - ori(down));
				x1 = x2;//做个记录
				chart.series[2].setData(middle(x2));
				chart.series[3].setData([[down,ori(down)],[up,ori(up)]]);
				chart.redraw();
			}
			else
			{
				if (ori(x1)==0)
				{
					diedaiEnd = true;
					print("<p>弦与x轴之交点刚好是解</p>");
					return;
				}
				if (ori(down)*ori(x1)>=0)
				{
					区间下限.text = x1.toString();
				}
				else
				{
					区间上限.text = x1.toString();
				}
				drawori();
				chart.series[0].setData(data);
				chart.series[1].setData([[down,0],[up,0]]);
				chart.series[3].setData([[down,ori(down)],[up,ori(up)]]);
				chart.redraw();
			}



		}
		function secant2()
		{
			var x2:Number;
			if (time==0)
			{
				x0 = down;
				x1 = up;
			}

			x2 = x1 - ori(x1) * (x1 - x0) / (ori(x1) - ori(x0));
			x0 = x1;
			x1 = x2;
			if (x2==0)
			{
				diedaiEnd = true;
				print("<p>弦与x轴之交点刚好是解</p>");
				return;
			}
			if (x1<x0)
			{
				区间下限.text = x1.toString();
				区间上限.text = x0.toString();
			}
			else
			{
				区间上限.text = x1.toString();
				区间下限.text = x0.toString();
			}
			drawori();
			chart.series[0].setData(data);
			chart.series[1].setData([[down,0],[up,0]]);
			chart.series[3].setData([[down,ori(down)],[up,ori(up)]]);
			chart.redraw();

		}
		function timedCount()
		{
			cal();
			time++;
			if (! diedaiEnd && time < 50)
			{
				timer = setTimeout(function(){timedCount()},1000);
			}
			if (time==50)
			{
				print( "<p>迭代50次停止</p>");
			}
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
		function line(x:Number)
		{//求切线与x轴交点
			var k:Number,x1:Number;
			k=(ori(x+.000001)-ori(x))/.000001;//在x的导数

			if (int(k*1000)==0)
			{
				return 0.0;
			}
			else
			{

				x1 = x - ori(x) / k;/*x为切线与x轴的交点*/

				return x1;
			}
		}
		function erfen()
		{
			var mid:Number = (up + down) * .5;
			if (time%2==1)
			{

				if (ori(mid)>0)
				{
					区间上限.text = mid.toString();
				}
				else
				{
					区间下限.text = mid.toString();
				}
				drawori();
				chart.series[0].setData(data);
				chart.series[1].setData([[down,0],[up,0]]);
				chart.redraw();
			}
			else
			{
				chart.series[2].setData(middle(mid));
				chart.redraw();
			}

		}

		function ori(x:Number ):Number
		{
			return procFun.doEval(compObj1.PolishArray,[x]);
		}

		function drawori()
		{
			data.splice(0,data.length);
			//注意不能data=[];
			var i;
			var x = down;
			for (i=0; i<dataNumber; i++)
			{
				data.push([x,ori(x)]);
				x +=  interval;
			}
		}
	}
}