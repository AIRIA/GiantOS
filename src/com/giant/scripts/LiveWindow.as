import com.giant.configures.RouteDictionary;
import com.giant.configures.StatusConfigure;
import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.nets.NetConfig;
import com.giant.nets.SocketClient;
import com.giant.utils.JsonUtil;
import com.giant.vo.commands.Room;
import com.giant.windows.LiveWindow;

import flash.net.Socket;
import flash.utils.Dictionary;

import mx.controls.Alert;
import mx.events.FlexEvent;

private var socket:Socket;
[Bindable]
private var socketClient:SocketClient;

protected function createComplete(event:FlexEvent):void
{
	socketClient = new SocketClient();
	ShareManager.port = NetConfig.TEA_PORT;
	socket = socketClient.getSocket();
	socket.addEventListener(GiantEvent.SERVER_CONNECTED,connectedHandler);
	socket.addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	ShareManager.liveRouteDic.registerWithObj(new Room(),getRoomData);
	ShareManager.liveRouteDic.registerWithString("get_room_info",getRoomInfo);
}

private function connectedHandler(event:GiantEvent):void
{
	var room:Room = new Room();
	room.roomId = "room_1";
	socketClient.sendMsg(JsonUtil.objToJson(room));
}

protected function getRoomData(data:Object):void
{
	if(data.msg=="success"){
		StatusConfigure.liveConnected = true;
	}
}

protected function closeSocket():void
{
	if(socket.connected)
	{
		socket.close();
	}
	ShareManager.liveRouteDic = new RouteDictionary();
}

private function getRoomInfo(data:Object):void
{
	chatPanel.dispatchEvent(new GiantEvent(GiantEvent.GET_ROOM_INFO,data));
}

protected function recvDataHandler(event:GiantEvent):void
{
	trace("recv data:"+event.data);
	ShareManager.liveRouteDic.recvRoute(event.data.toString());
}