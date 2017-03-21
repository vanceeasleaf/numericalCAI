package 
{
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash .display .Sprite ;
	public class textFieldFocus extends Sprite
	{
		public function textFieldFocus(textFields:Array ,reset:Function )
		{
			for each (var textField:TextField in textFields)
			{
				new InputChange(textField,reset);
			}
			addEventListener(Event.ADDED_TO_STAGE,AddedToStageHandler);         
		}
		function AddedToStageHandler(e:Event ){
						stage.addEventListener(MouseEvent.CLICK,textFieldFocusLost);
		}
		function textFieldFocusLost(e:MouseEvent )
		{
			if ((e.target !==stage.focus)&&(e.target.parent!==stage.focus)) {
			stage.focus=stage;
			}
		}
	}

}