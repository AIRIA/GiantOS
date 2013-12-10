import com.giant.components.GiantPanel;
import com.giant.nets.SocketClient;
import com.giant.windows.ClientWindow;
import com.giant.windows.LiveWindow;

import mx.events.FlexEvent;

// ActionScript file
private var liveWindow:LiveWindow;
private var clientWindow:ClientWindow;


protected function appStart(event:FlexEvent):void
{
	
}

public function openApp(appName:String,width:Number,height:Number):void
{
	var cls:Class = getDefinitionByName(appName) as Class;
	var app:GiantPanel = new cls();
	app.width = width;
	app.height = height;
	app.x = 100;
	app.y = 100;
	windowGroup.addElement(app);
}