import com.giant.configures.NetConfig;
import com.giant.configures.RouteDictionary;
import com.giant.configures.RouteName;
import com.giant.events.GiantEvent;
import com.giant.managers.EventManager;
import com.giant.managers.NetManager;
import com.giant.managers.ShareManager;
import com.giant.nets.SocketClient;
import com.giant.stream.SoundStream;
import com.giant.stream.VideoStream;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;
import com.giant.vo.msgs.Person;

import flash.events.Event;
import flash.external.ExternalInterface;

import mx.events.FlexEvent;

[Bindable]
private var client:SocketClient;
[Bindable]
private var route:RouteDictionary = new RouteDictionary();

protected function createComplete(event:Event):void
{
	var name:String = ExternalInterface.call("randomChar",6);
	Person.getPerson().name = name;
	status.text = "正在加载配置文件...";
	Util.loadServerInfo();
	var param:Object = root.loaderInfo.parameters;
	Util.warnTip(param.room);
	ShareManager.streamName = Room.getRoom().roomId = param.room;
	EventManager.instance().addEventListener(GiantEvent.HANDS_UP,handsUpHandler);
	EventManager.instance().addEventListener(GiantEvent.LOADED_SERVER_INFO,connectServer);
}

protected function updateUserInfo(event:GiantEvent):void
{
	
	ShareManager.streamName = Room.getRoom().roomId = event.data.roomId;
}

protected function handsUpHandler(event:GiantEvent):void
{
	client.sendMsg(JSON.stringify({
		route:'hands_up',
		type:'ask',
		id:Person.getPerson().id
	}));
}

protected function connectServer(event:GiantEvent):void
{
	status.text = "正在连接服务器...";
	ShareManager.port = NetConfig.STU_PORT;
	ShareManager.client = client = new SocketClient();
	client.getSocket().addEventListener(GiantEvent.SERVER_CONNECTED,connectServerHandlder);
	client.getSocket().addEventListener(GiantEvent.CLOSE_CONNECT,closeConnectHandler);
	client.getSocket().addEventListener(GiantEvent.RECV_DATA,recvDataHandler);
	route.registerWithObj(Person.getPerson(),loginServerRes);
	route.registerWithString(RouteName.GET_ROOM_INFO,getRoomInfo);
	route.registerWithString(RouteName.ERROR_MSG,msgErrorHandler);
	route.registerWithString(RouteName.STUDENT_INFO,getStudentInfo);
	route.registerWithString(RouteName.ALLOW_ASK,allowAskHandler);
	route.registerWithString(RouteName.REFUSE_ASK,refuseAskHandler);
	route.registerWithString(RouteName.LISTEN_ASK,listenHandler);
	route.registerWithString(RouteName.WATCH_VIDEO,watchVideoHandler);
	route.registerWithString(RouteName.LIVE_END,liveEndHandler);
	route.registerWithString(RouteName.FETCH_VIDEO,fetchVideoHandler);
	route.registerWithObj(new PPTItem(),getPPTInfo);
}

private function fetchVideoHandler(data:Object):void
{
	if(data.stuId==Person.getPerson().id)
	{
		watchVideoHandler(data);
	}
}

private function liveEndHandler(data:Object):void
{
	EventManager.instance().dispatchEvent(new GiantEvent(RouteName.LIVE_END));
}

private function watchVideoHandler(data:Object):void
{
	ShareManager.streamName = data.streamName;
	ShareManager.rtmpHost = data.host;
	if(data.host)
	{
		playServerHandler(data);
		Util.info("[RTMP PLAY SERVER]"+ data.host,"red");
	}
	
	/*NetManager.getInstance().getIdlePlayServer({
		chName:"ccsrc",
		chId:ShareManager.streamName,
		uId:Person.getPerson().id,
		osType:"flash"
	},playServerHandler);*/
}

private function playServerHandler(data:Object):void
{
	Util.warnTip("老师开始发布视频了，现在开始连接服务器!");
	EventManager.instance().dispatchEvent(new GiantEvent(GiantEvent.WATCH_VIDEO,{
		host:ShareManager.rtmpHost,
		streamName:ShareManager.streamName
	}));
}


private function listenHandler(data:Object):void
{
	if(data.id!=Person.getPerson().id)
	{
		SoundStream.create().listen(data);
	}
}

private function refuseAskHandler(data:Object):void
{
	EventManager.instance().dispatchEvent(new GiantEvent(RouteName.REFUSE_ASK,data));
	
}

private function allowAskHandler(data:Object):void
{
	EventManager.instance().dispatchEvent(new GiantEvent(RouteName.ALLOW_ASK,data));
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
	person.roomId = Room.getRoom().roomId;
	person.type = "cmd";
	client.sendMsg(JsonUtil.objToJson(person));
	Util.warnTip("欢迎进入在线教学系统!");
	/*removeElement(loginLayer);*/
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