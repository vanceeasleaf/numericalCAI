package gauseslim{
	import command.ICommand;
	import flash.utils.ByteArray;
	public class CommandValish2 implements ICommand {
		private var valishNum1:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		public function CommandValish2(valishNum1:int,coeficients:Array,labels:Array) {
			this.valishNum1=valishNum1;
			this.coeficients=coeficients;

			this.labels=labels;
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
			for (var i=0; i<valishNum1; i++) {
				coeficients[i][labels[0].length-1]=coeficients[i][labels[0].length-1]-coeficients[valishNum1][labels[0].length-1]*coeficients[i][valishNum1];
				labels[i][labels[0].length-1].text=floor(coeficients[i][labels[0].length-1],2);
				coeficients[i][valishNum1]=0;
				labels[i][valishNum1].text=0;
			}
		}
		function floor(num:Number,n:uint):Number {
			var a:Number=Math.pow(10,n);
			if(num<0){
				return int(num*a-.5)/a;
			}else{
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