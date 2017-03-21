package 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	public class InputChange
	{
		private var _textField:TextField;
		private var _change = false;
		private var _callback:Function;
		public function InputChange(textField:TextField,callback:Function)
		{
			this._callback = callback;
			this._textField = textField;
			textField.addEventListener(Event.CHANGE,onChange);
			textField.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		function onChange(e:Event)
		{
			_change = true;
		}
		function onFocusOut(e:FocusEvent)
		{
			if (_change)
			{
				_callback();
				_change = false;
			}
		}
	}
}