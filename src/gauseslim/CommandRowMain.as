package gauseslim{
	import command.ICommand;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	public class CommandRowMain implements ICommand {
		private var row:int;
		private var coeficients:Array;
		private var labels:Array;
		private var maxIndex:int;

		public function CommandRowMain(row:int,coeficients:Array,labels:Array) {
			this.row=row;
			this.coeficients=coeficients;
			this.labels=labels;
		}
		public function execute():void {//找出列主元并换到指定位置
			maxIndex=row;
			for (var i=row+1; i<labels.length; i++) {
				maxIndex=Math.abs(coeficients[i][row])>Math.abs(coeficients[maxIndex][row])?i:maxIndex;
			}
				labels[maxIndex][row].setTextFormat(new TextFormat(null,null,0xff0000));
			if (maxIndex!=row) {
				exchangeRow(row,maxIndex);
			}
		}
		function exchangeRow(row1:int,row2:int) {
			for (var j:int; j<labels[0].length; j++) {
				var temptextField:TextField=labels[row1][j];
				labels[row1][j]=labels[row2][j];
				labels[row2][j]=temptextField;
				var tempNumber:Number=coeficients[row1][j];
				coeficients[row1][j]=coeficients[row2][j];
				coeficients[row2][j]=tempNumber;
				var a:Tween=new Tween(labels[row1][j],"y",Regular.easeOut,labels[row1][j].y,labels[row2][j].y,10,false);
				var b:Tween=new Tween(labels[row2][j],"y",Regular.easeOut,labels[row2][j].y,labels[row1][j].y,10,false);

			}
		}
		public function undo():void {
			exchangeRow(row,maxIndex);
		}
	}

}