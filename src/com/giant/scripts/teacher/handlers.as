import com.giant.events.GiantEvent;
import com.giant.managers.ShareManager;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;

import flash.events.MouseEvent;

// ActionScript file
protected function connectServerHandlder(event:GiantEvent):void
{
	status.text = "当前状态[在线]"
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
	route.registerWithObj(new PPTItem(),getPPTInfo);
	client.sendMsg(JsonUtil.objToJson(room));
	client.sendMsg(JsonUtil.objToJson(pptItem));
	chatPanel.dispatchEvent(event);
}

private function nextPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId;
	if(pptIdx<ShareManager.pptList.length)
	{
		pptPanel.pptItem = JsonUtil.jsonToObj(ShareManager.pptList[pptIdx],PPTItem);
		pptPanel.pptItem.roomId = roomId;
		client.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
}

private function prevPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId-1;
	if(pptIdx>0)
	{
		pptPanel.pptItem = JsonUtil.jsonToObj(ShareManager.pptList[pptIdx-1],PPTItem);
		pptPanel.pptItem.roomId = roomId;
		client.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
}

/* 获取到ppt列表后  广播老师显示的页数 */
private function getPPTInfo(data:Object):void
{
	Util.info("[recv]"+data);
}
