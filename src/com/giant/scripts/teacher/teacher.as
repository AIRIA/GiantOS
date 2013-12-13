import com.giant.configures.RouteDictionary;
import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.nets.NetConfig;
import com.giant.nets.SocketClient;
import com.giant.vo.commands.Room;

import flash.events.Event;

import mx.events.FlexEvent;

[Bindable]
private var client:SocketClient;
[Bindable]
private var route:RouteDictionary = new RouteDictionary();

// ActionScript file
/**
 * 程序创建完毕后 发送房间信息到服务器
 */
protected function createComplete(event:FlexEvent):void
{
	loginLayer.addEventListener(GiantEvent.INPUT_NAME_ENDED,connectServer);
}

protected function connectServer(event:GiantEvent):void
{
	status.text = "正在连接服务器...";
	Room.getRoom().roomId = event.data.roomId;
	ShareManager.port = NetConfig.TEA_PORT;
	client = new SocketClient();
	client.getSocket().addEventListener(GiantEvent.SERVER_CONNECTED,connectServerHandlder);
	client.getSocket().addEventListener(GiantEvent.CLOSE_CONNECT,closeConnectHandler);
	client.getSocket().addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	route.registerWithObj(Room.getRoom(),getRoomData);
	route.registerWithString("get_room_info",getRoomInfo);
	route.registerWithString("error_msg",msgErrorHandler);
	route.registerWithString("hands_up",handsUpHandler);
	route.registerWithString("student_login",stuLoginHandler);
	route.registerWithString("student_logout",stuLogoutHandler);
}

private function stuLogoutHandler(data:Object):void
{
	onlineList.dispatchEvent(new GiantEvent(GiantEvent.STU_LOGOUT,data));
}

private function stuLoginHandler(data:Object):void
{
	onlineList.dispatchEvent(new GiantEvent(GiantEvent.STU_LOGIN,data));
}

private function handsUpHandler(data:Object):void
{
	onlineList.dispatchEvent(new GiantEvent(GiantEvent.HANDS_UP,data));
}

protected function closeConnectHandler(event:GiantEvent):void
{
	status.text = "当前状态:[离线]";
	chatPanel.dispatchEvent(event);
}

private function msgErrorHandler(data:Object):void
{
	Util.alert(data.msg);
}

private function getRoomInfo(data:Object):void
{
	chatPanel.dispatchEvent(new GiantEvent(GiantEvent.GET_ROOM_INFO,data));
	onlineList.dispatchEvent(new GiantEvent(GiantEvent.GET_ROOM_INFO,data));
}

private function getRoomData(data:Object):void
{
	
}

protected function recvDataHandler(event:GiantEvent):void
{
	trace("recv data:"+event.data);
	route.recvRoute(event.data.toString());
}
