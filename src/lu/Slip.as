package lu{
	import command.ICommand;
	public class Slip implements ICommand {
		private var rowNum:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		private var isL:Boolean;
		public function Slip(rowNum:int,coeficients:Array,labels:Array,isL:Boolean) {
			this.rowNum=rowNum;
			this.coeficients=coeficients;
			this.labels=labels;
			this.isL=isL;
		}
		private function copy(a:Array):Array {
			/*var b:ByteArray=new ByteArray;
			b.writeObject(a);
			b.position=0;
			return b.readObject() as Array;*/
			var b:Array=new Array  ;
			for (var i in a) {
				b.push(a[i].concat());
			}
			return b;
		}
		public function execute():void {
			coeficients1=copy(coeficients);
			if (isL) {
				for (var i=0; i<labels.length; i++) {
					labels[i][i].text=1;
					for (var j=i+1; j<labels.length; j++) {
						labels[i][j].text=0;
					}
				}
			} else {
				undo();
				for (j=0; j<labels.length-1; j++) {
					for (i=j+1; i<labels.length; i++) {
						labels[i][j].text=0;
					}
				}
			}
		}
		function floor(num:Number,n:uint):Number {
			var a:Number=Math.pow(10,n);
			if (num<0) {
				return int(num*a-.5)/a;
			} else {
				return int(num*a+.5)/a;
			}
		}
		public function undo():void {
			coeficients=coeficients1;
			for (var i in labels) {
				for (var j in labels[i]) {
					labels[i][j].text=floor(coeficients1[i][j],2);
				}
			}
		}
	}
}