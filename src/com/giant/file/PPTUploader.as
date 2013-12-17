package com.giant.file
{
	import com.giant.utils.Util;
	import com.giant.vo.commands.Room;
	
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
			Util.warnTip("cancelHandler: " + event);
		}
		
		private function completeHandler(event:Event):void {
			Util.warnTip("completeHandler: " + event);
		}
		
		private function uploadCompleteDataHandler(event:DataEvent):void {
			Util.warnTip("uploadCompleteData: " + event);
		}
		
		private function httpStatusHandler(event:HTTPStatusEvent):void {
			Util.warnTip("httpStatusHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Util.warnTip("ioErrorHandler: " + event);
		}
		
		private function openHandler(event:Event):void {
			Util.warnTip("openHandler: " + event);
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var file:FileReference = FileReference(event.target);
			Util.warnTip("progressHandler name=" + file.name + " bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			Util.warnTip("securityErrorHandler: " + event);
		}
		
		private function selectHandler(event:Event):void {
			var file:FileReference = FileReference(event.target);
			Util.warnTip("selectHandler: name=" + file.name + " URL=" + urlReq.url);
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
			fileFilter = new FileFilter("PPT课件","*.ppt;*.pptx");
			types.push(fileFilter);
			urlReq = new URLRequest();
			var param:URLVariables = new URLVariables();
			param.roomId = Room.getRoom().roomId;
			urlReq.url = "http://192.168.2.170:8989/ppt/upload";
			urlReq.data = param;
			urlReq.method = URLRequestMethod.POST;
		}
	}
}