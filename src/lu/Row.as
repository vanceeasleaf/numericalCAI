package lu{
	import command.ICommand;
	public class Row implements ICommand {
		private var rowNum:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		public function Row(rowNum:int,coeficients:Array,labels:Array) {
			this.rowNum=rowNum;
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
			for (var j=rowNum; j<labels.length; j++) {
				var s:Number=0;
				for (var i=0; i<rowNum; i++) {
					s+=coeficients[rowNum][i]*coeficients[i][j];
				}
				coeficients[rowNum][j]=coeficients[rowNum][j]-s;
				labels[rowNum][j].text=floor(coeficients[rowNum][j],2);
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