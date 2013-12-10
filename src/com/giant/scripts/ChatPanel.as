import com.giant.components.ChatItem;
import com.giant.configures.RouteDictionary;
import com.giant.configures.StatusConfigure;
import com.giant.events.GiantEvent;
import com.giant.nets.SocketClient;
import com.giant.skins.GiantTextInputSkin;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.msgs.ChatMsg;

import flash.events.Event;

import mx.events.FlexEvent;
[Bindable]
public var btnLabel:String;
[Bindable]
public var routeDic:RouteDictionary;
[Bindable]
public var socketClient:SocketClient;
[Bindable]
public var onlineNum:Number = 0;
[Bindable]
public var sendEnable:Boolean = false;

protected function sendMsg(event:FlexEvent):void
{
	var date:Date = new Date();
	var hours:String = formatNum(date.getHours());
	var minutes:String = formatNum(date.getMinutes());
	var seconds:String = formatNum(date.getSeconds());
	var chatMsg:ChatMsg = new ChatMsg();
	
	chatMsg.time = hours+":"+minutes+":"+seconds;
	chatMsg.content = msgInput.text;
	chatMsg.roomId = "room_1";
	//chatMsg.human = Person.name;
	socketClient.sendMsg(JsonUtil.objToJson(chatMsg));
	msgInput.text = "";
}

private function addChatItem(msg:ChatMsg):void
{
	var chatItem:ChatItem = new ChatItem();
	chatItem.chatMsg = msg;
	chatGroup.addElement(chatItem);
}

private function formatNum(num:int):String{
	if(num<10){
		return "0"+num;
	}
	return num.toString();
}

public function recvChatMsg(msg:Object):void
{
	var chatMsg:ChatMsg = new ChatMsg();
	Util.decode(msg,chatMsg);
	addChatItem(chatMsg);
}

protected function createCompleteHandler(event:FlexEvent):void
{
	addEventListener(GiantEvent.GET_ROOM_INFO,updateInfoHandler);
	routeDic.registerWithObj(new ChatMsg,recvChatMsg);
}

protected function updateInfoHandler(event:GiantEvent):void
{
	var data:Object = event.data;
	onlineNum = data.total;
}