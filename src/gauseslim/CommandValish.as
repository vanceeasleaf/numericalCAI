package gauseslim{
	import flash.utils.ByteArray;
	import command.ICommand;
	public class CommandValish implements ICommand {//归一化及消去
		private var row:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		public function CommandValish(row:int,coeficients:Array,labels:Array) {
			this.row=row;
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
			for (var j:int=row+1; j<labels[0].length; j++) {
				coeficients[row][j]=coeficients[row][j]/coeficients[row][row];
				labels[row][j].text=floor(coeficients[row][j],2);
			}
			coeficients[row][row]=1;
			labels[row][row].text=1;//第k行的归一化，以上
			for (var i:int=row+1; i<labels.length; i++) {
				for (j=row+1; j<labels[i].length; j++) {
					coeficients[i][j]-=coeficients[i][row]*coeficients[row][j];
					labels[i][j].text=floor(coeficients[i][j],2);
				}
				coeficients[i][row]=0;
				labels[i][row].text=0;
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