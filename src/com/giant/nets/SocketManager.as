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
	
	import mx.controls.Alert;
	import mx.utils.ObjectUtil;
	
	import avmplus.getQualifiedClassName;

	public class SocketManager
	{
		private static var socket:Socket;
		public static function getSocket():Socket
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
			return socket;
		}
		/**
		 * 发送JSON格式的数据到socket服务器 
		 * @param msg
		 * 
		 */		
		public static function sendMsg(json:String):void
		{
			trace("send data:"+json);
			socket.writeMultiByte(json+"\n","UTF-8");
			socket.flush();
		}
		
		protected static function outputHandler(event:OutputProgressEvent):void
		{
			//Util.alert("send data");
		}
		
		protected static function getDataHandler(event:ProgressEvent):void
		{
			var jsonStr:String = socket.readMultiByte(socket.bytesAvailable,"UTF-8");
			RouteDictionary.recvRoute(jsonStr);
		}
		
		protected static function ioErrorHandler(event:IOErrorEvent):void
		{
			Util.alert("socket io error");
		}
		
		protected static function closeHandler(event:Event):void
		{
			StatusConfigure.connected = false;
			Alert.show("socket closed");
		}
		
		protected static function connectHandler(event:Event):void
		{
			Alert.show("socket connected");
			var socket:Socket = event.target as Socket;
			socket.dispatchEvent(new GiantEvent(GiantEvent.SERVER_CONNECTED));
		}
		
		protected static function securityErrorHandler(event:SecurityErrorEvent):void
		{
			Util.alert("security error occur");
		}
	}
}