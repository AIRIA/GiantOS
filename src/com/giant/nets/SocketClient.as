package com.giant.nets
{
	import com.giant.configures.RouteDictionary;
	import com.giant.configures.StatusConfigure;
	import com.giant.events.GiantEvent;
	import com.giant.managers.ShareManager;
	import com.giant.utils.Util;
	 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	
	import avmplus.getQualifiedClassName;

	public class SocketClient
	{
		private var socket:Socket;
		public function SocketClient()
		{
			Security.loadPolicyFile("xmlsocket://192.168.2.170:9703");
			socket = new Socket();
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			socket.addEventListener(Event.CONNECT,connectHandler);
			socket.addEventListener(Event.CLOSE,closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,getDataHandler);
			socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,outputHandler);
			socket.connect(NetConfig.SERVER_IP,ShareManager.port);
		}
		
		public function getSocket():Socket
		{
			return socket;
		}
		
		/**
		 * 发送JSON格式的数据到socket服务器 
		 * @param msg
		 * 
		 */		
		public function sendMsg(json:String):void
		{
			trace("send data:"+json);
			Util.info("[send]"+json);
			socket.writeMultiByte(json+"\n","UTF-8");
			socket.flush();
		}
		
		protected function outputHandler(event:OutputProgressEvent):void
		{
			//Util.alert("send data");
		}
		
		protected function getDataHandler(event:ProgressEvent):void
		{
			var jsonStr:String = socket.readMultiByte(socket.bytesAvailable,"UTF-8");
			Util.info("[recv]"+jsonStr);
			socket.dispatchEvent(new GiantEvent(GiantEvent.RECV_DATA,jsonStr));
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			Util.alert("socket io error");
		}
		
		protected function closeHandler(event:Event):void
		{
			socket.dispatchEvent(new GiantEvent(GiantEvent.CLOSE_CONNECT));
		}
		
		protected function connectHandler(event:Event):void
		{
			socket.dispatchEvent(new GiantEvent(GiantEvent.SERVER_CONNECTED));
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			Util.alert("security error occur");
		}
	}
}