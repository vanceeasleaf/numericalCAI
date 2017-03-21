package command{
	import ICommand;
	public class CommandStack {
		private var _instance:CommandStack;
		private var _commands:Array;
		private var _index:uint;

		public function CommandStack(parameter:SingletonEnforcer) {
			_commands=new Array  ;
			_index=0;
		}
		public static function getInstance():CommandStack {
			if (_instance==null) {
				_instance=new CommandStack(new SingletonEnforcer  );
			}
			return _instance;
		}
		public function putCommand(command:ICommand):void {
			_commands[_index++]=command;
			_commands.splice(_index,_command.length-_index);
		}
		public function previous():void {
			return _commands[--_index];
		}
		public function next():void {
			return _commands[_index++];
		}
		public function hasPreviousCommands():Boolean {
			return _index>0;
		}
		public function hasNextCommands():Boolean {
			return _index>0;
		}
	}
}
}
class SingletonEnforcer{};