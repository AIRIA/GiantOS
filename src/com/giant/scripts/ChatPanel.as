import com.giant.components.ChatItem;
import com.giant.components.ChatTip;
import com.giant.configures.RouteDictionary;
import com.giant.configures.RouteName;
import com.giant.configures.StatusConfigure;
import com.giant.events.GiantEvent;
import com.giant.managers.EventManager;
import com.giant.nets.SocketClient;
import com.giant.skins.GiantTextInputSkin;
import com.giant.stream.SoundStream;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.msgs.ChatMsg;
import com.giant.vo.msgs.Person;

import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.Label;
[Bindable]
public var btnLabel:String = "";
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
	chatMsg.human = Person.getPerson().name;
	socketClient.sendMsg(JsonUtil.objToJson(chatMsg));
	msgInput.text = "";
}

private function addChatItem(msg:ChatMsg):void
{
	var chatItem:ChatItem = new ChatItem();
	chatItem.chatMsg = msg;
	chatGroup.addElement(chatItem);
	chatGroup.validateNow();
	chatScroller.verticalScrollBar.value = chatScroller.verticalScrollBar.maximum;
}

private function showExtraInfo(info:String):void
{
	
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
	addEventListener(GiantEvent.SERVER_CONNECTED,connectedHandler);
	addEventListener(GiantEvent.CLOSE_CONNECT,closeHandler);
	addEventListener(GiantEvent.GET_ROOM_INFO,updateInfoHandler);
	EventManager.instance().addEventListener(RouteName.ALLOW_ASK,allowAskHandler);
	EventManager.instance().addEventListener(RouteName.REFUSE_ASK,refuseAskHandler);
	EventManager.instance().addEventListener(GiantEvent.SYS_WARN_INFO,addWarnHandler);
	EventManager.instance().addEventListener(GiantEvent.SYS_ERROR_INFO,addErrorHandler);
	
	routeDic.registerWithObj(new ChatMsg,recvChatMsg);
}

protected function refuseAskHandler(event:GiantEvent):void
{
	speakBtn.enabled = true;
	Util.errorTip("老师拒绝了您本次的发言,耐心等待下次提问！");
}

protected function allowAskHandler(event:GiantEvent):void
{
	speakBtn.enabled = true;
	Util.warnTip("老师允许了你的提问，请抓紧发言...");
	SoundStream.create().push();
}

protected function addWarnHandler(event:GiantEvent):void
{
	addTip(event.data as String);
}

protected function addErrorHandler(event:GiantEvent):void
{
	addTip(event.data as String);
}

protected function addTip(info:String):void
{
	var tip:ChatTip = new ChatTip();
	tip.tip = info;
	chatGroup.addElement(tip);
	chatGroup.validateNow();
	chatScroller.verticalScrollBar.value = chatScroller.verticalScrollBar.maximum;
}

protected function closeHandler(event:Event):void
{
	msgInput.enabled = false;
}

protected function connectedHandler(event:Event):void
{
	msgInput.enabled = true;
}

protected function updateInfoHandler(event:GiantEvent):void
{
	var data:Object = event.data;
	onlineNum = data.total;
}