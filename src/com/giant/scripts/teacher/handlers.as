import com.giant.events.GiantEvent;
import com.giant.managers.EventManager;
import com.giant.managers.ShareManager;
import com.giant.utils.JsonUtil;
import com.giant.utils.Util;
import com.giant.vo.commands.Room;
import com.giant.vo.msgs.PPTItem;

import flash.events.MouseEvent;

// ActionScript file
/**
 * socket服务器连接成功后触发 
 */
protected function connectServerHandlder(event:GiantEvent):void
{
	Util.warnTip("欢迎进入在线教学系统");
	ShareManager.connected = true;
	removeElementAt(numElements-1);
	status.text = "当前状态[在线]";
	client.sendMsg(JsonUtil.objToJson(Room.getRoom()));
	chatPanel.dispatchEvent(event);
	EventManager.instance().addEventListener(GiantEvent.GET_PPTLIST,initPPTHandler);
	route.registerWithObj(new PPTItem(),getPPTInfo);
}

/**
 * 初始化PPT列表信息 
 */
protected function initPPTHandler(event:GiantEvent):void
{
	var pptItem:PPTItem = ShareManager.pptList[0];
	pptPanel.pptItem = pptItem;
	pptPanel.nextPage = nextPage;
	pptPanel.prevPage = prevPage;
	
	client.sendMsg(JsonUtil.objToJson(pptItem));
}

private function nextPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId+1;
	if(pptIdx<ShareManager.pptList.length)
	{
		pptPanel.pptItem = ShareManager.pptList[pptIdx];
		pptPanel.pptItem.roomId = Room.getRoom().roomId;
		client.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
}

private function prevPage(event:MouseEvent):void
{
	var pptIdx:Number = pptPanel.pptItem.pageId-1;
	if(pptIdx>=0)
	{
		pptPanel.pptItem =ShareManager.pptList[pptIdx];
		pptPanel.pptItem.roomId = Room.getRoom().roomId;
		client.sendMsg(JsonUtil.objToJson(pptPanel.pptItem));
	}
}

/* 获取到ppt列表后  广播老师显示的页数 */
private function getPPTInfo(data:Object):void
{
	Util.info("[recv]"+data);
}
