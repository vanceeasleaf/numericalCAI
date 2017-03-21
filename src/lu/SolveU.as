package lu{
	import command.ICommand;
	public class SolveU  implements ICommand{
		private var row:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		public function SolveU(row:int,coeficients:Array,labels:Array) {
			this.row=row;
			this.coeficients=coeficients;
			this.labels=labels;
		}
		private function copy(a:Array):Array {
			var b:Array=new Array  ;
			for (var i in a) {
				b.push(a[i].concat());
			}
			return b;
		}
		public function execute():void {
			var a:int=labels.length;
			coeficients1=copy(coeficients);
			for(var j=a;j>=row;j--){
				coeficients[row][j]/=coeficients[row][row];
				labels[row][j].text=floor(coeficients[row][j],2);
			}
			for (var i=0; i<row; i++) {
				coeficients[i][a]-=coeficients[row][a]*coeficients[i][row];
				labels[i][a].text=floor(coeficients[i][a],2);
				coeficients[i][row]=0;
				labels[i][row].text=0;
			}
			coeficients[row][row]=1;
			labels[row][row].text=1;
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
