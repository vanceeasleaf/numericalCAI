package lu
{
	import command.*;
	public class LUdisorb
	{
		private var coeficients:Array;
		private var labels:Array;
		private var num:int;
		private var row:int;
		public var commands:CommandStack = new CommandStack  ;
		public function LUdisorb(coeficients:Array,labels:Array)
		{
			this.coeficients = coeficients;
			this.labels = labels;
			init();
		}
		private function init()
		{
			row = 0;
			num = 0;
			var stop:Boolean = false;
			while (! stop)
			{
				num++;
				if (((num % 2) == 0))
				{
					var command1:ICommand = new Row(row,coeficients,labels);
				}
				else if ((row < labels.length - 1))
				{
					command1 = new Collumn(row,coeficients,labels);
					row++;
				}
				else
				{
					//command1=new Slip(row,coeficients,labels,true);
					//commands.putCommand(command1);
					//command1=new Slip(row,coeficients,labels,false);
					stop = true;
				}
				if (! stop)
				{
					commands.putCommand(command1);
				}
			}//分解阶段

			var generateL:GenerateL = new GenerateL(row,coeficients,labels);
			commands.putCommand(generateL);
			
			for (row = 0; row < labels.length - 1; row++)
			{
				command1 = new SolveL(row,coeficients,labels);
				commands.putCommand(command1);
			}
			command1 = new GenerateU(row,coeficients,labels,generateL);
			commands.putCommand(command1);
			for (row = labels.length - 1; row >=0; row--)
			{
				command1 = new SolveU(row,coeficients,labels);
				commands.putCommand(command1);
			}
			commands.resetIndex();
		}
		public function next()
		{
			if (commands.hasNextCommands)
			{
				commands.next.execute();
			}
		}
		public function previous()
		{
			if (commands.hasPreviousCommands)
			{
				commands.previous.undo();
			}
		}
	}

}