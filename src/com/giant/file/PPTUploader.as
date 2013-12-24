package com.giant.file
{
	import com.giant.configures.NetConfig;
	import com.giant.events.GiantEvent;
	import com.giant.events.PPTEvent;
	import com.giant.managers.EventManager;
	import com.giant.managers.ShareManager;
	import com.giant.utils.Util;
	import com.giant.vo.commands.Room;
	import com.giant.vo.msgs.PPTItem;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class PPTUploader
	{
		private var urlReq:URLRequest;
		private var file:FileReference;
		private static var _instance:PPTUploader;
		private var fileFilter:FileFilter;
		private var types:Array = [];
		
		public static function instance():PPTUploader
		{
			if(!_instance)
			{
				_instance = new PPTUploader();
			}
			return _instance;
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.CANCEL, cancelHandler);
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			dispatcher.addEventListener(Event.SELECT, selectHandler);
			dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadCompleteDataHandler);
		}
		
		private function cancelHandler(event:Event):void {
			Util.info("cancelHandler: " + event);
		}
		
		private function completeHandler(event:Event):void {
			Util.info("completeHandler: " + event);
		}
		
		private function uploadCompleteDataHandler(event:DataEvent):void {
			Util.info("uploadCompleteData: " + event);
			var imgsUrl:Array = JSON.parse(event.data).body.jpgs;
			ShareManager.pptList = [];
			for(var i:int=0;i<imgsUrl.length;i++)
			{
				var pptItem:PPTItem = new PPTItem();
				pptItem.source = NetConfig.PPT_SERVER+imgsUrl[i];
				pptItem.pageId = i;
				pptItem.name = "Page"+i;
				ShareManager.pptList.push(pptItem);
			}
			EventManager.instance().dispatchEvent(new GiantEvent(GiantEvent.GET_PPTLIST));
			EventManager.instance().dispatchEvent(new Event(PPTEvent.LOADED));
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			Util.info("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Util.info("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			EventManager.instance().dispatchEvent(new Event(PPTEvent.UPLOAD));
			Util.info("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			Util.info("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Util.info("securityErrorHandler: " + event);
		}
		
		private function selectHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			Util.info("selectHandler: name=" + file.name + " URL=" + urlReq.url);
			file.upload(urlReq,"upfile");
		}
		
		public function upload():void
		{
			file.browse(types);
		}
		
		public function PPTUploader()
		{
			file = new FileReference();
			configureListeners(file);
			fileFilter = new FileFilter("PPT课件(*.ppt,*.pptx)","*.ppt;*.pptx");
			types.push(fileFilter);
			urlReq = new URLRequest();
			var param:URLVariables = new URLVariables();
			param.roomId = Room.getRoom().roomId;
			urlReq.url = NetConfig.PPT_SERVER+"file/upload";
			urlReq.data = param;
			urlReq.method = URLRequestMethod.POST;
		}
	}
}