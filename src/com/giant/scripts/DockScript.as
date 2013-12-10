import flash.display.StageDisplayState;
import flash.events.MouseEvent;

// ActionScript file

private function fullscreen(event:MouseEvent=null):void
{
	stage.displayState = stage.displayState==StageDisplayState.FULL_SCREEN_INTERACTIVE?StageDisplayState.NORMAL:StageDisplayState.FULL_SCREEN_INTERACTIVE;
}