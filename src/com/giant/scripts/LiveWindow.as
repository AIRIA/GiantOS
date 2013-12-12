import com.giant.configures.RouteDictionary;
import com.giant.configures.StatusConfigure;
import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.nets.NetConfig;
import com.giant.nets.SocketClient;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;
import com.giant.windows.LiveWindow;

import flash.events.MouseEvent;
import flash.net.Socket;
import flash.utils.Dictionary;

import mx.controls.Alert;
import mx.events.FlexEvent;

private var socket:Socket;
[Bindable]
private var socketClient:SocketClient;
[Bindable]
private var roomId:String = "room_1";

protected function createComplete(event:FlexEvent):void
{
	socketClient = new SocketClient();
	ShareManager.port = NetConfig.TEA_PORT;
	socket = socketClient.getSocket();
	socket.addEventListener(GiantEvent.SERVER_CONNECTED,connectedHandler);
	socket.addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	ShareManager.liveRouteDic.registerWithObj(new Room(),getRoomData);
	ShareManager.liveRouteDic.registerWithString("get_room_info",getRoomInfo);
	ShareManager.liveRouteDic.registerWithString("error_msg",msgErrorHandler);
}

private function msgErrorHandler(data:Object):void
{
	
}
/* 获取到ppt列表后  广播老师显示的页数 */
private function getPPTInfo(data:Object):void
{
	Util.info("[recv]"+data);
}

private function connectedHandler(event:GiantEvent):void
{
	var room:Room = new Room();
	room.roomId = roomId;
	var pptItem:PPTItem = new PPTItem();
	pptItem.pageId = 1;
	pptItem.type = "ppt";
	pptItem.roomId = "room_1";
	pptItem.source = "ppts/1.jpg";
	pptItem.name = "name1";
	pptPanel.pptItem = pptItem;
	pptPanel.nextPage = nextPage;
	pptPanel.prevPage = prevPage;
	ShareManager.liveRouteDic.registerWithObj(new PPTItem(),getPPTInfo);
	socketClient.sendMsg(JsonUtil.objToJson(room));
	socketClient.sendMsg(JsonUtil.objToJson(pptItem));
}

private function nextPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId;
	if(pptIdx<ShareManager.pptList.length)
	{
		pptPanel.pptItem = JsonUtil.jsonToObj(ShareManager.pptList[pptIdx],PPTItem);
		pptPanel.pptItem.roomId = roomId;
		socketClient.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
}

private function prevPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId-1;
	if(pptIdx>0)
	{
		pptPanel.pptItem = JsonUtil.jsonToObj(ShareManager.pptList[pptIdx-1],PPTItem);
		pptPanel.pptItem.roomId = roomId;
		socketClient.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
	
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