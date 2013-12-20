import com.giant.configures.NetConfig;
import com.giant.configures.RouteDictionary;
import com.giant.configures.RouteName;
import com.giant.events.GiantEvent;
import com.giant.file.PPTUploader;
import com.giant.managers.EventManager;
import com.giant.managers.NetManager;
import com.giant.managers.ShareManager;
import com.giant.nets.SocketClient;
import com.giant.stream.SoundStream;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;
import com.giant.vo.msgs.Person;

import flash.events.Event;
import flash.events.MouseEvent;

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
	loginLayer.addEventListener(GiantEvent.INPUT_NAME_ENDED,updateUserInfo);
	EventManager.instance().addEventListener(GiantEvent.LOADED_SERVER_INFO,connectServer);
}

protected function updateUserInfo(event:GiantEvent):void
{
	status.text = "正在加载配置文件...";
	Util.loadServerInfo();
	ShareManager.streamName = Room.getRoom().roomId = event.data.roomId;
}

/**
 * 连接socket服务器 
 */
protected function connectServer(event:GiantEvent):void
{
	status.text = "正在连接服务器...";
	ShareManager.port = NetConfig.TEA_PORT;
	ShareManager.client = client = new SocketClient();
	client.getSocket().addEventListener(GiantEvent.SERVER_CONNECTED,connectServerHandlder);
	client.getSocket().addEventListener(GiantEvent.CLOSE_CONNECT,closeConnectHandler);
	client.getSocket().addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	route.registerWithObj(Room.getRoom(),getRoomData);
	route.registerWithString(RouteName.GET_ROOM_INFO,getRoomInfo);
	route.registerWithString(RouteName.ERROR_MSG,msgErrorHandler);
	route.registerWithString(RouteName.HANDS_UP,handsUpHandler);
	route.registerWithString(RouteName.STUDENT_LOGIN,stuLoginHandler);
	route.registerWithString(RouteName.STUDENT_LOGOUT,stuLogoutHandler);
	route.registerWithString(RouteName.LISTEN_ASK,listenHandler);
}

private function browsePPT(event:MouseEvent):void
{
	PPTUploader.instance().upload();
}

private function publishVideo(event:MouseEvent):void
{
	NetManager.getInstance().getIdlePushServer({
		chName:"ccsrc",
		chId:ShareManager.streamName,
		uId:"tempUID",
		osType:"flash"
	},getPushServerHandler);
}

private function getPushServerHandler(data:Object):void
{
	EventManager.instance().dispatchEvent(new GiantEvent(GiantEvent.PUBLISH_VIDEO,{
		host:data.body.ip,
		streamName:ShareManager.streamName
	}));		
}

private function endPublish(event:MouseEvent):void
{
	
}

private function listenHandler(data:Object):void
{
	if(data.id!=Person.getPerson().id)
	{
		SoundStream.create().listen(data);
	}
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
