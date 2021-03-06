﻿package lu
{
	import command.ICommand;
	public class GenerateU implements ICommand
	{
		private var row:int;
		private var coeficients:Array;
		private var coeficients1:Array;
		private var labels:Array;
		private var generateL:GenerateL;
		public function GenerateU(row:int,coeficients:Array,labels:Array,generateL:GenerateL)
		{
			this.row = row;
			this.coeficients = coeficients;
			this.labels = labels;
			this.generateL = generateL;
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
			var q:int = labels.length;
			coeficients1 = copy(coeficients);

			var a = generateL.coefs;
			for (var j:int = 0; j < q; j++)
			{
				for (var i = 0; i <=j; i++)
				{
					coeficients[i][j] = a[i][j];
					labels[i][j].text = floor(coeficients[i][j],2);
				}
			}

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