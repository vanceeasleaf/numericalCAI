package lu
{
	import command.ICommand;
	public class GenerateL implements ICommand
	{
		private var row:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		public function GenerateL(row:int,coeficients:Array,labels:Array)
		{
			this.row = row;
			this.coeficients = coeficients;
			this.labels = labels;
		}
		private function copy(a:Array):Array
		{
			var b:Array = new Array  ;
			for (var i in a)
			{
				b.push(a[i].concat());
			}
			return b;
		}
		public function execute():void
		{
			var a:int = labels.length;
			coeficients1 = copy(coeficients);

			for (var j:int = 0; j < a; j++)
			{
				for (var i = 0; i < j; i++)
				{

					coeficients[i][j] = 0;
					labels[i][j].text = 0;
				}
			}
			for (i=0; i<a; i++)
			{
				coeficients[i][i] = 1;
				labels[i][i].text = 1;
			}
		}
		public function get coefs():Array
		{
			return coeficients1;
		}
		function floor(num:Number,n:uint):Number
		{
			var a:Number = Math.pow(10,n);
			if ((num < 0))
			{
				return int(((num * a) - .5)) / a;
			}
			else
			{
				return int(((num * a) + .5)) / a;
			}
		}
		public function undo():void
		{
			coeficients = coeficients1;
			for (var i in labels)
			{
				for (var j in labels[i])
				{
					labels[i][j].text = floor(coeficients1[i][j],2);
				}
			}
		}


	}

}