package gauseslim{
	import command.*;
	public class ValishCollumn {
		private var valishNum:int;
		private var valishNum1:int;
		private var coeficients:Array;
		private var labels:Array;
		private var num:int;
		public var commands:CommandStack=new CommandStack  ;
		public function ValishCollumn(coeficients:Array,labels:Array) {
			this.coeficients=coeficients;
			this.labels=labels;
			init();
		}
		private function init() {
			valishNum=0;
			valishNum1=labels.length-1;
			while (valishNum1>0) {
				num++;
				if (valishNum<labels.length) {
					if (num%2==1&&valishNum<labels.length-1) {
						var command1:ICommand=new CommandRowMain(valishNum,coeficients,labels);
					} else {
						command1=new CommandValish(valishNum,coeficients,labels);
						valishNum++;
					}
				} else {
					command1=new CommandValish2(valishNum1,coeficients,labels);
					valishNum1--;
				}
				commands.putCommand(command1);
			}
			commands.resetIndex();
		}
		public function next() {
			if (commands.hasNextCommands) {
				commands.next.execute();
			}
		}
		public function previous() {
			if (commands.hasPreviousCommands) {
				commands.previous.undo();
			}
		}
	}
}