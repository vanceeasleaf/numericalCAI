package mychart{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.filters.ShaderFilter;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	import flash.events.Event;
	import com.greensock.TweenMax;
	import com.greensock .easing .*
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	import fl.transitions.TweenEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Chart {
		public var series:Array=[];
		private var xAxis:Axis;
		private var yAxis:Axis;
		private var renderTo:MovieClip;
		private var chart:Sprite;
		private var mask:Sprite;
		private var cavasMask:Sprite;
		private var seriesCavas:Sprite;
		private var plotWidth:int;
		private var plotHeight:int;
		private var tickLength:int=4;
		private var marginTop:Number;
		private var marginLeft:Number;
		private var cavas:Sprite;
		private var axisCavas:Sprite;
		private var textFormat:TextFormat;
		private var hasRendered:Boolean;
		private var animation:Number=0;
		private var sketch:Boolean;
		private var data:Array=[];
		public function Chart(options:Object) {
			this.renderTo=options.renderTo;
			chart=new Sprite 
			renderTo.addChild (chart);
			this.marginTop=options.margin[0];
			var marginRight=options.margin[1];
			var marginBottom=options.margin[2];
			this.marginLeft=options.margin[3];
			plotWidth=Math.round(renderTo.width-marginLeft-marginRight);
			plotHeight=Math.round(renderTo.height-marginTop-marginBottom);
			for each (var serieOptions in options.series||[]) {
				initSeries(serieOptions);
			}
			if(!options.axis){
				options.axis=[];
			}
			this.xAxis=new Axis(true,this.series,plotWidth,plotHeight,options.axis[0]||NaN,options.axis[1]||NaN);
			this.yAxis=new Axis(false,this.series,plotWidth,plotHeight,options.axis[2]||NaN,options.axis[3]||NaN);
			initCavas();
			render();

		}
		function initSeries(serieOptions:Object) {
			var serie:Serie=new Serie(serieOptions);
			this.series.push(serie);
		}
		function setMask() {
			mask=new Sprite  ;
			chart.addChild(mask);
			mask.graphics.lineStyle(0);
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0,0,(renderTo.width)/renderTo.scaleX,(renderTo.height)/renderTo.scaleY);
			mask.graphics.endFill();
			chart.mask=mask;
		}
		function setCavasMask() {
			cavasMask=new Sprite  ;
			cavasMask.visible=false;
			cavas.addChild(cavasMask);
			cavasMask.graphics.lineStyle(0);
			cavasMask.graphics.beginFill(0);
			cavasMask.graphics.drawRect(- tickLength,- tickLength,plotWidth+2*tickLength,plotHeight+2*tickLength);
			cavasMask.graphics.endFill();
			
		}
		function initCavas() {
			setMask();
			cavas=new Sprite  ;
			cavas.scaleX =1/renderTo.scaleX;
			cavas.scaleY =1/renderTo.scaleY;
			cavas.x=marginLeft/renderTo.scaleX;;
			cavas.y=marginTop/renderTo.scaleY;;
			chart.addChild(cavas);
			cavas.graphics.lineStyle(0,0x009999,0.3);
			cavas.graphics.moveTo(- tickLength,plotHeight);
			cavas.graphics.lineTo((plotWidth+tickLength),plotHeight);
			seriesCavas=new Sprite 
			cavas.addChild(seriesCavas);
			setCavasMask();
			seriesCavas.mask =cavasMask
			textFormat=new TextFormat  ;
			textFormat.font="Lucida Sans Unicode";
			textFormat.size=11;
			textFormat.color=0x666666;
			textFormat.align="right";

		}
		function drawTicks() {
			if (axisCavas) {
				cavas.removeChild(axisCavas);
			}
			axisCavas=new Sprite  ;
			cavas.addChild(axisCavas);
			axisCavas.graphics.lineStyle(0,0x009999,0.3);
			for each (var tick in xAxis.tickPositions) {
				axisCavas.graphics.moveTo(xAxis.translate(tick),plotHeight);
				axisCavas.graphics.lineTo(xAxis.translate(tick),plotHeight+tickLength);
				var la:TextField=new TextField  ;
				la.selectable=false;
				la.autoSize="center";
				la.text=tick;
				if (hasRendered) {
					var oldPos=xAxis.translate(tick,false,true)-la.textWidth/2-2;
					var newPos=xAxis.translate(tick)-la.textWidth/2-2;
					new Tween(la,"x",Regular.easeOut,oldPos,newPos,5);
				} else {
					la.x=xAxis.translate(tick)-la.textWidth/2-2;
				}
				la.y=plotHeight;
				la.setTextFormat(textFormat);
				axisCavas.addChild(la);
			}
			for each (tick in yAxis.tickPositions) {
				axisCavas.graphics.moveTo(0,yAxis.translate(tick));
				axisCavas.graphics.lineTo(-4,yAxis.translate(tick));
				la=new TextField  ;
				la.selectable=false;
				//la.autoSize="right";
				la.text=tick;
				la.x=- la.width-4;
				if (hasRendered) {
					oldPos=yAxis.translate(tick,false,true)-la.textHeight/2-2;
					newPos=yAxis.translate(tick)-la.textHeight/2-2;
					new Tween(la,"y",Regular.easeOut,oldPos,newPos,5);
				} else {
					la.y=yAxis.translate(tick)-la.textHeight/2-2;
				}
				la.setTextFormat(textFormat);
				axisCavas.addChild(la);
			}
		}
		function updatePoint(e:Event) {
			var scatter=new Scatter(e.target.color,e.target.radius);
			scatter.x=xAxis.translate(e.target.data[e.target.data.length-1][0]);
			scatter.y=yAxis.translate(e.target.data[e.target.data.length-1][1]);
			e.target.scatters.push(scatter);
			e.target.addChild(scatter);
			redraw();
		}
		function drawSeries() {
			var serie:Serie;
			var point:Array;
			var data:Array;
			for each (serie in series) {
				serie.addEventListener("addpoint",updatePoint);

				seriesCavas.addChild(serie);
				data=new Array  ;
				for each (point in serie.data) {
					data.push([xAxis.translate(point[0]),yAxis.translate(point[1])]);
				}
				serie.pixelData=data;
				serie.zero=yAxis.translate(0);
				if (serie.type==='line') {
					serie.graphics.lineStyle(2,serie.color);
					var needNotLineTo:Boolean=true;
					for each (point in serie.pixelData) {
						if (needNotLineTo) {
							serie.graphics.moveTo(point[0],point[1]);
							needNotLineTo=false;
						} else {
							serie.graphics.lineTo(point[0],point[1]);
						}
					}
				} else if (serie.type==='scatter') {
					for each (point in serie.pixelData) {
						var scatter=new Scatter(serie.color,serie.radius );
						scatter.x=point[0];
						scatter.y=point[1];
						serie.scatters.push(scatter);
						serie.addChild(scatter);
					}
				} else if (serie.type==='area'&&serie.data.length>0) {
					serie.graphics.lineStyle(0,serie.color);
					serie.graphics.beginFill(serie.color);
					serie.graphics.moveTo(serie.pixelData[0][0],yAxis.translate(0));
					for each (point in serie.pixelData) {
						serie.graphics.lineTo(point[0],point[1]);
					}
					serie.graphics.lineTo(serie.pixelData[serie.pixelData.length-1][0],yAxis.translate(0));
					serie.graphics.lineTo(serie.pixelData[0][0],yAxis.translate(0));
					serie.graphics.endFill();
				}
			}
		}
		function redrawSerie(serie:Serie,data:Array,zero:Number) {
			serie.graphics.clear();
			if (serie.type==='line') {
				serie.graphics.lineStyle(2,serie.color);
				var needNotLineTo:Boolean=true;
				for each (var point in data) {
					if (needNotLineTo) {
						serie.graphics.moveTo(point[0],point[1]);
						needNotLineTo=false;
					} else {
						serie.graphics.lineTo(point[0],point[1]);
					}
				}
			} else if (serie.type==='scatter') {
				for (var i:int=serie.scatters.length-1; i>=0; i--) {
					serie.removeChildAt(i);
					serie.scatters.pop();
				}
				for each (point in data) {
					var scatter=new Scatter(serie.color,serie.radius);
					scatter.x=point[0];
					scatter.y=point[1];
					serie.scatters.push(scatter);
					serie.addChild(scatter);
				}
			} else if (serie.type==='area'&&data.length>0) {
				serie.graphics.lineStyle(0,serie.color);
				serie.graphics.beginFill(serie.color);
				serie.graphics.moveTo(data[0][0],zero);
				for each (point in data) {
					serie.graphics.lineTo(point[0],point[1]);
				}
				serie.graphics.lineTo(data[data.length-1][0],zero);
				serie.graphics.lineTo(data[0][0],zero);
				serie.graphics.endFill();
			}
		}
		function drawLegend() {
			var legend:Legend=new Legend(this.series);
			for each (var legendLabel in legend.legendLabels) {
				legendLabel.addEventListener("update",updateScale);
			}
			legend.scaleX =1/renderTo.scaleX;
			legend.scaleY =1/renderTo.scaleY;
			chart.addChild(legend);
			legend.x=mask.width/2-legend.width/2+marginLeft/(4*renderTo.scaleX);
			legend.y=mask.height-20/renderTo.scaleY-legend.height;
		}
		function updateScale(e:Event=null) {

			redraw();
		}
		function updateData() {
			var point;
			xAxis.setScale();
			yAxis.setScale();
			var isScaled:Boolean=xAxis.needRedraw||yAxis.needRedraw;
			var choose:Boolean;
			if (isScaled) {
				drawTicks();
			}
			for each (var serie in series) {
				choose=serie.needRedraw||isScaled;
				if (choose) {
					if (serie.visible) {
						serie.oldPixelData=serie.pixelData.concat();
						serie.oldZero=serie.zero;
						var data:Array=new Array  ;
						for each (point in serie.data) {
							data.push([xAxis.translate(point[0]),yAxis.translate(point[1])]);
						}
						serie.pixelData=data;
						serie.zero=yAxis.translate(0);
					}
				}
			}
			//var a:Tween=new Tween(this,"animation",Regular.easeOut,0,1,10);
			//a.addEventListener(TweenEvent.MOTION_FINISH,tweenStop1);
			cavas.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			animation=0;
		}

		function onEnterFrame(e:Event) {
			var serie:Serie,data:Array,x,y,u,v,i;
			var isScaled:Boolean=xAxis.needRedraw||yAxis.needRedraw;
			var choose:Boolean;
			for each (serie in series) {
				choose=sketch?(! serie.needRedraw)&&isScaled:serie.needRedraw||isScaled;
				if (choose&&serie.visible) {
					data=[];
					for (i in serie.pixelData) {
						x=serie.pixelData[i][0];
						y=serie.pixelData[i][1];
						if ((i<serie.oldPixelData.length)) {
							u=isNaN(serie.oldPixelData[i][0])?x:serie.oldPixelData[i][0];
							v=isNaN(serie.oldPixelData[i][1])?y:serie.oldPixelData[i][1];
						} else {
							u=x;
							v=y;
						}
						x=x*animation+(1-animation)*u;
						y=y*animation+(1-animation)*v;
						data.push([x,y]);
					}
					var zero=serie.zero;
					zero=zero*animation+(1-animation)*serie.oldZero;
					redrawSerie(serie,data,zero);
				}
			}
			if ((animation==1)) {
				cavas.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				for each (serie in series) {
					serie.needRedraw=false;
				}
			}
			animation+=.2;
			if ((animation>1)) {
				animation=1;
			}
		}
		public function redraw(sketch:Boolean=false) {
			this.sketch=sketch;
			updateData();
			if (sketch) {
				drawSeriesWithAnimation();
			}
		}
		public function drawNow(){
			for each (var serie in series) {
				if (serie.needRedraw) {
					
						serie.oldPixelData=serie.pixelData.concat();
						serie.oldZero=serie.zero;
						var data:Array=new Array  ;
						for each (var point in serie.data) {
							data.push([xAxis.translate(point[0]),yAxis.translate(point[1])]);
						}
						serie.pixelData=data;
						serie.zero=yAxis.translate(0);
					
				}
				serie.needRedraw=false;
				redrawSerie(serie,serie.pixelData,serie.zero);
			}
		}
		function drawSeriesWithAnimation() {
			var serie:Serie;
			var point:Array;
			for each (serie in series) {
				if (serie.needRedraw&&serie.visible) {
					serie.graphics.clear();
					if (serie.type==='line') {
						serie.graphics.lineStyle(2,serie.color);
						var needNotLineTo:Boolean=true;
						for each (point in serie.pixelData) {
							if (needNotLineTo) {
								serie.graphics.moveTo(point[0],point[1]);
								needNotLineTo=false;
							} else {
								serie.graphics.lineTo(point[0],point[1]);
							}
						}
						serie.mask=cavasMask;
					} else if (serie.type==='scatter') {
						for (var i:int=serie.scatters.length-1; i>=0; i--) {
							serie.removeChildAt(i);
							serie.scatters.pop();
						}
						for each (point in serie.pixelData) {
							var scatter=new Scatter(serie.color);
							scatter.x=point[0];
							scatter.y=point[1];
							serie.scatters.push(scatter);
							serie.addChild(scatter);
						}
					} else if (serie.type==='area'&&serie.data.length>1) {
						serie.graphics.lineStyle(0,serie.color);
						serie.graphics.beginFill(serie.color);
						serie.graphics.moveTo(serie.pixelData[0][0],serie.zero);
						for each (point in serie.pixelData) {
							serie.graphics.lineTo(point[0],point[1]);
						}
						serie.graphics.lineTo(serie.pixelData[serie.pixelData.length-1][0],serie.zero);
						serie.graphics.lineTo(serie.pixelData[0][0],serie.zero);
						serie.graphics.endFill();
					}
					serie.mask=cavasMask;
				}
			}cavasMask.x=tickLength;
			TweenMax.from(cavasMask, .5, {x:-plotWidth, ease:Sine.easeInOut});
						//var a:Tween=new Tween(cavasMask,"x",Regular.easeOut,-plotWidth,tickLength,12);
			//a.addEventListener(TweenEvent.MOTION_FINISH,tweenStop1);
			
		}
		function render() {
			drawTicks();
			drawSeries();
			drawLegend();
			hasRendered=true;
		}//endof function
		public function dispose(){
			
		}
	}
}