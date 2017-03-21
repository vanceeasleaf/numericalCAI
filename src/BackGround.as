package 
{
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	//import flash.events.FullScreenEvent; 
	public class BackGround extends Sprite
	{
		private var bitmapData:BitmapData ;
		public function BackGround()
		{
			addEventListener(Event.ADDED_TO_STAGE,AddedToStageHandler);
		}
		function AddedToStageHandler(e:Event):void
		{
			drawImage();
			stage.addEventListener(Event.RESIZE, resizeStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}

		private function drawImage():void
		{
			bitmapData = new background  ;
			resetStage();
		}
		private function resizeStage(Evt:Event):void
		{
			resetStage();
		}
		private function resetStage()
		{
			this.graphics.beginBitmapFill(bitmapData);
			this.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight);
			this.graphics.endFill();
		}
	}
}