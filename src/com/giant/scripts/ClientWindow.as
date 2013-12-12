import com.giant.configures.RouteDictionary;
import com.giant.configures.StatusConfigure;
import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.nets.NetConfig;
import com.giant.nets.SocketClient;
import com.giant.utils.JsonUtil;
import com.giant.vo.msgs.PPTItem;
import com.giant.vo.msgs.Person;

import flash.net.Socket;

import mx.controls.Alert;
import mx.events.FlexEvent;
private var socket:Socket;
[Bindable]
private var socketClient:SocketClient;

protected function createComplete(event:FlexEvent):void
{
	ShareManager.port = NetConfig.STU_PORT;
	socketClient = new SocketClient();
	socket = socketClient.getSocket();
	socket.addEventListener(GiantEvent.SERVER_CONNECTED,connectedHandler);
	socket.addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	//注册路由
	ShareManager.clientRouteDic.registerWithObj(new Person(),recvData);
	ShareManager.clientRouteDic.registerWithString("get_room_info",getRoomInfo);
	ShareManager.clientRouteDic.registerWithString("error_msg",msgErrorHandler);
	ShareManager.clientRouteDic.registerWithObj(new PPTItem(),getPPTInfo);
}

private function msgErrorHandler(data:Object):void
{
	
}
/**
 * 获取老师正在播放的ppt信息
 */
private function getPPTInfo(data:Object):void
{
	var pptItem:PPTItem = JsonUtil.jsonToObj(data,PPTItem);
	pptPanel.pptItem = pptItem;
}
private function connectedHandler(event:GiantEvent):void
{
	var person:Person = new Person();
	person.roomId = "room_1";
	person.type = "cmd";
	socketClient.sendMsg(JsonUtil.objToJson(person));
}
public function recvData(data:Object):void
{
	if(data.msg=="success")
	{
		StatusConfigure.clientConnected = true;
	}
}

public function closeSocket():void
{
//	socket.removeEventListener(GiantEvent.RECV_DATA,recvDataHandler);
//	socket.removeEventListener(GiantEvent.GET_ROOM_INFO,getRoomInfo);
//	socket.removeEventListener(GiantEvent.SERVER_CONNECTED,connectedHandler);
	if(socket.connected)
	{
		socket.close();
	}
	ShareManager.clientRouteDic = new RouteDictionary();
}

public function getRoomInfo(data:Object):void
{
	chatPanel.dispatchEvent(new GiantEvent(GiantEvent.GET_ROOM_INFO,data));
}

protected function recvDataHandler(event:GiantEvent):void
{
	ShareManager.clientRouteDic.recvRoute(event.data.toString());
}