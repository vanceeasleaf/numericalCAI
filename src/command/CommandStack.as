package command{
	public class CommandStack {
		private var _instance:CommandStack;
		private var _commands:Array;
		private var _index:uint;

		public function CommandStack() {
			_commands=new Array  ;
			_index=0;
		}
		public function resetIndex(){
		_index=0;
		}
		public function putCommand(command:ICommand):void {
			_commands[_index++]=command;
			_commands.splice(_index,_commands.length-_index);
		}
		public function get previous():ICommand {
			return _commands[--_index];
		}
		public function get next():ICommand {
			return _commands[_index++];
		}
		public function get hasPreviousCommands():Boolean {
			return _index>0;
		}
		public function get hasNextCommands():Boolean {
			return _index<_commands.length;
		}
	}
}
