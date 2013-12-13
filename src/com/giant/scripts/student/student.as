import com.giant.configures.RouteDictionary;
import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.nets.NetConfig;
import com.giant.nets.SocketClient;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;
import com.giant.vo.msgs.Person;

import flash.events.Event;

import mx.events.FlexEvent;

[Bindable]
private var client:SocketClient;
[Bindable]
private var route:RouteDictionary = new RouteDictionary();
[Bindable]
private var roomId:String = "room_1";

protected function createComplete(event:FlexEvent):void
{
	loginLayer.addEventListener(GiantEvent.INPUT_NAME_ENDED,connectServer);
}

protected function connectServer(event:Event):void
{
	status.text = "正在连接服务器...";
	ShareManager.port = NetConfig.STU_PORT;
	client = new SocketClient();
	client.getSocket().addEventListener(GiantEvent.SERVER_CONNECTED,connectServerHandlder);
	client.getSocket().addEventListener(GiantEvent.CLOSE_CONNECT,closeConnectHandler);
	client.getSocket().addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	route.registerWithObj(Person.getPerson(),loginServerRes);
	route.registerWithString("get_room_info",getRoomInfo);
	route.registerWithString("error_msg",msgErrorHandler);
	route.registerWithString("student_info",getStudentInfo);
	route.registerWithObj(new PPTItem(),getPPTInfo);
	
}

private function getStudentInfo(data:Object):void
{
	Person.getPerson().id = data.id;
}

/**
 * 连接服务器成功后 发送学生登录的信息
 */
protected function connectServerHandlder(event:GiantEvent):void
{
	var person:Person = Person.getPerson();
	person.roomId = "room_1";
	person.type = "cmd";
	client.sendMsg(JsonUtil.objToJson(person));
}
/**
 * 学生登录的结果
 */
private function loginServerRes(data:Object):void
{
	if(data.msg=="success")
	{
		status.text = "当前状态:[在线]";
		chatPanel.dispatchEvent(new GiantEvent(GiantEvent.SERVER_CONNECTED));
	}else{
		Util.alert(data.msg);
	}
}

public function getRoomInfo(data:Object):void
{
	chatPanel.dispatchEvent(new GiantEvent(GiantEvent.GET_ROOM_INFO,data));
}

protected function closeConnectHandler(event:GiantEvent):void
{
	status.text = "当前状态:[离线]";
	chatPanel.dispatchEvent(event);
}

/**
 * 获取老师正在播放的ppt信息
 */
private function getPPTInfo(data:Object):void
{
	var pptItem:PPTItem = JsonUtil.jsonToObj(data,PPTItem);
	pptPanel.pptItem = pptItem;
}

protected function recvDataHandler(event:GiantEvent):void
{
	trace("recv data:"+event.data);
	route.recvRoute(event.data.toString());
}


private function msgErrorHandler(data:Object):void
{
	
}