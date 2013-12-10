import com.giant.components.DeskIcon;
import com.giant.components.GiantPanel;
import com.giant.nets.SocketClient;
import com.giant.windows.ClientWindow;
import com.giant.windows.LiveWindow;

import flash.events.MouseEvent;

import mx.events.FlexEvent;

// ActionScript file
private var liveWindow:LiveWindow;
private var clientWindow:ClientWindow;


protected function appStart(event:FlexEvent):void
{
	
}

public function openApp(event:MouseEvent,appName:String,width:Number,height:Number):void
{
	var deskIcon:DeskIcon = event.target as DeskIcon;
	var cls:Class = getDefinitionByName(appName) as Class;
	var app:GiantPanel = new cls();
	app.icon = deskIcon.icon;
	app.width = width;
	app.height = height;
	app.x = 100;
	app.y = 100;
	windowGroup.addElement(app);
}