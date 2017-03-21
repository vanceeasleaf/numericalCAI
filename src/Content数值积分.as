package 
{
	import mychart.*;
	import bkde.as3.parsers.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.data.DataProvider;
	import flash.text.TextFormat;
	import fl.controls.ComboBox;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;

	public class Content数值积分 extends MovieClip
	{
		//常量
		private var dataNumber:int = 201;
		var procFun:MathParser;
		var compObj1:CompiledObject;
		function get interval():Number
		{
			return (up-down)/(dataNumber-1);
		}
		var gridModel:Object = {k:'',S:'',T:'',C:'',R:''};
		var formatString:String = '0.###';
		var C:Array=[
		[1.0/2,1.0/2],//n=1
		[1.0/6,4.0/6,1.0/6],
		[1.0/8,3.0/8,3.0/8,1.0/8], 
		[7.0/90,16.0/45,2.0/15,16.0/45,7.0/90], 
		[19.0/288,25.0/96,25.0/144,25.0/144,25.0/96,19.0/188], //n=5
		[41.0/840,9.0/35,9.0/280,34.0/105,9.0/280,9.0/35,41.0/840],
		[429.0/9871,337.0/1628,49.0/640,585.0/3382,585.0/3382,49.0/640,337.0/1628,429.0/9871],
		[248.0/7109,578.0/2783,-111.0/3391,97.0/262,-454.0/2835,97.0/262,-111.0/3391,578.0/2783,248.0/7109]
		];
		//全局传参量
		var chart:Chart;
		var timer:int;
		var rtime:int;//龙贝格方法计数;
		var diedaiend:Boolean = false;
		var c2:*;//积分误差;
		var X:Array = [];//插值点
		var Y:Array = [];
		var data:Array = [];//原函数
		var table:Array = [];//表格数据
		var tableObject:Array = [];//表格数据
		//常用一次性变量
		var i:int;
		var methodNumber:String = "1";
		public function Content数值积分():void
		{
			procFun = new MathParser(["x"]);
			compObj1 = procFun.doCompile(Input_func.text);
			mygrid.visible = false;
			gridm.visible = false;
			text.visible = true;
			//一次性变量
			var tf:TextFormat = new TextFormat  ;
			tf.size = 20;
			tf.align = "center";
			text.setStyle("textFormat",tf);
			gridm.setStyle("textFormat",tf);
			spin.setStyle("textFormat",tf);
			//text.setTextFormat(tf);用于textField;
			//精度要求.text="2";精度要求.restrict="0-9//-.";
			//区间上限.text="2";
			//区间下限.text="-2";
			for (i=0; i<15; i++)
			{
				tableObject.push({k:'',S:'',T:'',C:'',R:''});
				table.push([]);
			}
			mygrid.dataProvider = new DataProvider(tableObject);
			mygrid.columns = ["k","T","S","C","R"];//设置header
			for (i=0; i<5; i++)
			{
				mygrid.getColumnAt(i).resizable = false;
				mygrid.getColumnAt(i).sortable = false;
			}
			var tf1:TextFormat = new TextFormat();
			tf1.size = 13;
			tf1.align = "center";
			mygrid.setRendererStyle("textFormat", tf1);
			//这是设置表内单元格上的文字样式;
			mygrid.setStyle("headerTextFormat", tf1);
			//这是设置表头上的单元格文字格式;
			drawori(data);
			var options:Object={
			renderTo:chartFrame,
			margin:[4,4,64,44],
			series:[
			{name:'原函数',type:'line',data:data,color:0x000FF0},
			{name:'插值点',type:'scatter',data:[],color:0xFF0000},
			{name:'逼近函数',type:'area',data:[],color:0x000FF0,alpha:0.4}
			]
			};
			chart = new Chart(options);

			for each (var textField:TextField in [区间上限,区间下限,精度要求])
			{
				new InputChange(textField,reset);
			}
			new InputChange(Input_func,funcReset);
			function funcReset()
			{
				compObj1 = procFun.doCompile(Input_func.text);
				reset();
			}
			自动演示.addEventListener(MouseEvent.CLICK,on自动演示);
			重新开始.addEventListener(MouseEvent.CLICK,on重新开始);
			停止.addEventListener(MouseEvent.CLICK,on停止);
			method.addEventListener(Event.CHANGE,onmethod);
			spin.addEventListener(Event.CHANGE,spinchange);
			//动态更改不触发;
		}

		//UI输入量
		function get up():Number
		{
			return parseFloat(区间上限.text);
		}

		function get down():Number
		{
			return parseFloat(区间下限.text);
		}
		function get precision():int
		{
			return parseInt(精度要求.text);
		}
		function get num():int
		{
			return spin.value;//计时的数有num和rtime;
		}
		function set num(a:int):void
		{
			spin.value = a;
		}
		function gridRefresh()
		{
			var i:int;
			for (i=0; i<15; i++)
			{
				tableObject[i]['k'] = format(table[i][0],'0.###');
				tableObject[i]['T'] = format(table[i][1],'0.###');
				tableObject[i]['S'] = format(table[i][2],'0.###');
				tableObject[i]['C'] = format(table[i][3],'0.###');
				tableObject[i]['R'] = format(table[i][4],'0.###');
			}
			mygrid.invalidateList();
		}
		//validateNow()，这个是在 DataGrid 的属性（大小，位置等）改变时，进行手动刷新的。我们要刷新纪录，就要用 invalidateList() ;

		function reset()
		{
			drawori(data);
			chart.series[0].setData(data,false);
			chart.series[1].setData([],false);
			chart.series[2].setData([],false);
			chart.redraw();
			spin.value = 2;
			clearTimeout(timer);
			text.text = '';
			resetGrid();
		}
		function resetGrid()
		{
			var i:int,j;
			if (methodNumber=="4"&&rtime!=0)
			{
				for (i=0; i<15; i++)
				{
					table[i] = [];
					for (j in gridModel)
					{
						tableObject[i][j] = ' ';
					}
				}
				mygrid.invalidateList();
				rtime = 0;
				gridm.text = '';
			}
		}
		function on自动演示(e:MouseEvent)
		{
			if (isNaN(timer)==false)
			{
				clearTimeout(timer);
			}
			num=(spin.value<8&&!diedaiend)?spin.value:2;
			resetGrid();
			diedaiend = false;
			timedCount();
		}

		function on重新开始(e:MouseEvent)
		{
			区间上限.text = "2";
			区间下限.text = "-2";
			reset();
		}

		function on停止(e:MouseEvent)
		{
			if (isNaN(timer)==false)
			{
				clearTimeout(timer);
			}
		}


		function onmethod(e:Event)
		{
			methodNumber = method.value;
			if (isNaN(timer)==false)
			{
				clearTimeout(timer);
			}
			reset();
			if (methodNumber=="1")
			{
				spin.maximum = 8;
			}
			else
			{
				spin.maximum = 201;
			}
			if (methodNumber=="4")
			{
				mygrid.visible = true;
				gridm.visible = true;
				text.visible = false;
			}
			else
			{
				mygrid.visible = false;//隐藏
				gridm.visible = false;//隐藏
				text.visible = true;
			}
		}
		function spinchange(e:Event)
		{
			cal();
		}
		function timedCount()
		{
			var i:int;
			switch (methodNumber)
			{
				case "1" :
					num++;
					cal();
					if (num<7)
					{
						timer = setTimeout(function(){timedCount()},1000);
					}
					break;
				case "2" :
				case "3" :
					num = 2 * (num - 1) + 1;//分段数翻
					cal();
					var p1 = Math.pow(0.1,precision);
					var p2 = precision;
					p1 = p1.toFixed(p2);
					if (num<200&&c2>p1)
					{
						timer = setTimeout(function(){timedCount()},1000);
					}
					if (c2<p1)
					{
						text.htmlText +=  "<p ><font color='#000000'>达到精度要求" + p1 + "停止迭代</font></p>";
					}
					if (num>=200&&c2>p1)
					{
						text.htmlText +=  "<p ><font color='#000000'>没有收敛到精度要求" + p1 + "停止迭代</font></p>";
					}
					text.verticalScrollPosition = text.maxVerticalScrollPosition;
					diedaiend = true;
					break;
				case "4" :
					if (rtime==0)
					{
						for (i=0; i<4; i++)
						{
							table[i][0] = i;
							table[i][1] = ctranz0(down,up,Math.pow(2,i));
						}
						//设定k和T
					}
					if (rtime==1)
					{
						for (i=0; i<3; i++)
						{
							table[i][2]=1/3*(4*table[i+1][1]-table[i][1]);
						}
						//S
					}
					if (rtime==2)
					{
						for (i=0; i<2; i++)
						{
							table[i][3]=1/15*(16*table[i+1][2]-table[i][2]);
						}
						//C
					}
					if (rtime==3)
					{
						table[0][4]=1/63*(64*table[1][3]-table[0][3]);
					}
					//R;
					if (rtime>3)
					{
						if ((rtime+1)%4==1)
						{
							i=Math.round((rtime+1)/4)+3;
							table[i][1] = ctranz0(down,up,Math.pow(2,i));
							table[i][0] = i;
						}
						if ((rtime+1)%4==2)
						{
							i=Math.round((rtime+1)/4)+1;
							table[i][2]=1/3*(4*table[i+1][1]-table[i][1]);
						}
						if ((rtime+1)%4==3)
						{
							i=Math.round((rtime+1)/4);
							table[i][3]=1/15*(16*table[i+1][2]-table[i][2]);
						}
						if ((rtime+1)%4==0)
						{
							i=Math.round((rtime+1)/4)-1;
							table[i][4]=1/63*(64*table[i+1][3]-table[i][3]);
							var c1 = format(table[i][4],formatString);
							c2 = format(Math.abs(table[i][4] - table[i - 1][4]),'0.#########');
							gridm.htmlText +=  "<p ><font color='#f09514'>积分近似值=" + c1 + "</font></p>";
							gridm.htmlText +=  "<p ><font color='#000000'>误差=" + c2 + "</font></p>";
							gridm.verticalScrollPosition = gridm.maxVerticalScrollPosition;
							if (c2<Math.pow(0.1,precision))
							{
								diedaiend = true;
								gridm.htmlText +=  "<p ><font color='#f09514'>达到指定精度，停止迭代</font></p>";
								gridm.verticalScrollPosition = gridm.maxVerticalScrollPosition;
							}
						}
						if (rtime>30)
						{
							gridm.htmlText +=  "<p ><font color='#000000'>时间超过30秒，停止迭代，未达到指定精度</font></p>";
							gridm.verticalScrollPosition = gridm.maxVerticalScrollPosition;
							diedaiend = true;
						}
					}
					gridRefresh();
					rtime++;
					if (diedaiend==false)
					{
						timer = setTimeout(function(){timedCount()},1000);
					}
					break;
			}
		}
		function la(X:Array,Y:Array,x:Number,n:uint)
		{//n个插值点
			var i,j;
			var Lx,Fx = 0;
			for (i=0; i<n; i++)
			{
				Lx = 1;
				for (j=0; j<n; j++)
				{
					if (j!=i)
					{
						Lx=Lx*((x-X[j])/(X[i]-X[j]));
					}
				}
				Fx=Fx+Lx*(Y[i]);
			}
			return Fx;
		}

		function cotes(a,b,n)
		{//等分n段
			//设置全局数组——牛顿 科特斯公式系数表 
			var Cotes:Number = 0.0;
			//计算科特斯公式的值 
			for (var j=0; j<=n; j++)
			{
				Cotes=Cotes+C[n-1][j]*ori((j*(b-a)/n)+a);
			}
			Cotes = (b - a) * Cotes;
			return Cotes;
		}
		function ctranz(a,b,e)
		{//复化梯形公式变步长
			var h,t0,t,g;
			//积分间隔
			h = (b - a) / 2;
			var n = 1;
			t = h * (ori(a) + ori(b));
			do
			{
				t0 = t;//上次结果         
				g = 0;
				for (var i=1; i<=n; i++)
				{
					g+=ori((a+(2*i-1)*h));
				}
				t = (t0 / 2) + (h * g);
				n *=  2;
				h /=  2;
			} while (Math.abs(t-t0)>e);
			return t;
		}
		function ctranz0(a,b,num)
		{//复化梯形公式,段数
			var h,fa,fb,xk,t;
			h = (b - a) / num;
			//步长
			fa = ori(a);
			fb = ori(b);
			var s = 0;
			for (var k=1; k<num; k++)
			{
				xk = a + k * h;
				s = s + ori(xk);
			}
			t = h * (fa + fb) / 2 + h * s;
			//复化梯形公式
			return t;
		}
		function sim(x,y,xx,num)
		{//n是表观插值点数，故2num-2为实际分段数
			for (var i=0; i<2*num-3; i+=2)
			{
				if (x[i] <= xx && xx <= x[i + 2])
				{
					break;
				}
			}
			var t1,t2,t3;
			t1=(xx-x[i+1])/(x[i]-x[i+1])*
			 (xx-x[i+2])/(x[i]-x[i+2])*y[i];
			t2=(xx-x[i])/(x[i+1]-x[i])*
			 (xx-x[i+2])/(x[i+1]-x[i+2])*y[i+1];
			t3=(xx-x[i])/(x[i+2]-x[i])*
			 (xx-x[i+1])/(x[i+2]-x[i+1])*y[i+2];
			return t1+t2+t3;
		}
		function csimpson(a,b,n)
		{//复化辛普森
			var h,fa,fb,xk,xj;
			h = (b - a) / n;
			fa = ori(a);
			fb = ori(b);
			var s1 = 0;
			var s2 = 0;
			for (var k=1; k<n; k++)
			{
				xk = a + k * h;
				s1 = s1 + ori(xk);
			}
			for (var j=0; j<n; j++)
			{
				xj = a + (j + 0.5) * h;
				s2 = s2 + ori(xj);
			}
			var sn;
			sn=h/6*(fa+fb+2*s1+4*s2);
			//复化Simpson公式
			return sn;
		}
		function ori(x:Number ):Number
		{
			trace(Input_func.text);
			return procFun.doEval(compObj1.PolishArray,[x]);
		}
		function cal()
		{
			var i:int,c1,a;
			var data1=new Array();//插值函数
			var data2=new Array();//插值点
			var x = down;
			if (methodNumber!="4")
			{
				for (i=0; i<num; i++)
				{
					X[i] = down + i * (up - down) / (num - 1);
					Y[i] = ori(X[i]);
					data2.push([X[i],Y[i]]);
				}
				if (methodNumber=="3")
				{
					for (i=0; i<2*num-1; i++)
					{
						X[i] = down + i * (up - down) / (num - 1);
						Y[i] = ori(X[i]);
					}
				}
				switch (methodNumber)
				{
					case "1" :
						for (i=0; i<(up-down)/interval+1; i++)
						{
							data1.push([x,la(X,Y,x,num)]);
							x +=  interval;
						}
						text.htmlText +=  "<p ><font color='#0000ff'>牛顿柯特斯公式：插值点数n=" + num + "</font></p><p ><font color='#0000ff'>柯特斯系数：</font></p>";
						for (i=1; i<=num; i++)
						{
							text.htmlText +=  "<p ><font color='#0000ff'>C[" + num + "," + i + "]=" + format(C[num - 1][i - 1],formatString) + "</font></p>";
						}

						text.htmlText +=  "<p ><font color='#000000'>积分近似值=(" + format(up,formatString) + "-(" + format(down,formatString) + "))*(";
						for (i=1; i<=num-1; i++)
						{
							text.htmlText +=  format(C[num - 1][i - 1],formatString) + "*(" + format(Y[i - 1],formatString) + ")+";
						}

						text.htmlText +=  format(C[num - 1][num - 1],formatString) + "*(" + format(Y[num - 1],formatString) + "))</font></p>";
						text.htmlText +=  "<p ><font color='#0000ff'>=" + format(cotes(down,up,num),formatString) + "</font></p>";
						text.verticalScrollPosition = text.maxVerticalScrollPosition;
						break;
					case "2" :
						data1 = data2;
						text.htmlText +=  "<p ><font color='#0000ff'>复化梯形公式：分段数n=" + (num - 1) + "</font></p>";
						a = ctranz0(down,up,num - 1);
						c1 = format(ctranz0(down,up,num - 1),formatString);
						c2=(num>3)?format(Math.abs(ctranz0(down,up,num-1)-ctranz0(down,up,(num-1)/2)),'0.#########'):"未知";
						text.htmlText +=  "<p ><font color='#000000'>积分近似值=" + c1 + "</font></p>";
						text.htmlText +=  "<p ><font color='#000000'>误差=" + c2 + "</font></p>";
						text.verticalScrollPosition = text.maxVerticalScrollPosition;
						break;
					case "3" :
						for (i=0; i<(up-down)/interval+1; i++)
						{
							data1.push([x,sim(X,Y,x,num)]);
							x +=  interval;
						}
						text.htmlText +=  "<p ><font color='#0000ff'>复化辛普森公式：分段数n=" + (num - 1) + "</font></p>";
						a = csimpson(down,up,num - 1);
						c1 = format(csimpson(down,up,num - 1),formatString);
						c2=(num>3)?format(Math.abs(csimpson(down,up,num-1)-csimpson(down,up,(num-1)/2)),'0.#########'):"未知";
						text.text +=  "积分近似值=" + c1;
						text.text +=  "误差=" + c2;
						text.verticalScrollPosition = text.maxVerticalScrollPosition;
						break;
				}
				chart.series[1].setData(data2,false);
				chart.series[2].setData(data1);
				chart.redraw(true);
			}
		}
		function drawori(data:Array)
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
		function format(number, form)
		{
			if (number==undefined)
			{
				return '';
			}
			var forms = form.split('.'), number = '' + number, numbers = number.split('.')
			        , leftnumber = numbers[0].split('')
			        , exec = function (lastMatch) {
			            if (lastMatch == '0' || lastMatch == '#') {
			                if (leftnumber.length) {
			                    return leftnumber.pop();
			                } else if (lastMatch == '0') {
			                    return lastMatch;
			                } else {
			                    return '';
			                }
			            } else {
			                return lastMatch;
			            }
			    }, string;
			string = forms[0].split('').reverse().join('').replace(/./g,exec).split('').reverse().join('');
			string = leftnumber.join('') + string;

			if (forms[1] && forms[1].length)
			{
				leftnumber = (numbers[1] && numbers[1].length) ? numbers[1].split('').reverse() : [];
				string +=  '.' + forms[1].replace(/./g,exec);
			}
			return string.replace(/\.$/, '');
		}
	}
}