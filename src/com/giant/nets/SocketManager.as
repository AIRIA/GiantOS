package com.giant.nets
{
	import com.giant.utils.Util;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;

	public class SocketManager
	{
		private static var socket:Socket;
		public static function getSocket():Socket
		{
			if(!socket)
			{
				Security.loadPolicyFile("xmlsocket://192.168.2.170:9703");
				socket = new Socket();
				socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
				socket.addEventListener(Event.CONNECT,connectHandler);
				socket.addEventListener(Event.CLOSE,closeHandler);
				socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
				socket.addEventListener(ProgressEvent.SOCKET_DATA,getDataHandler);
				socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,outputHandler);
				socket.connect(NetConfig.SERVER_IP,NetConfig.TEA_PORT);
			}
			return socket;
		}
		
		protected static function outputHandler(event:OutputProgressEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected static function getDataHandler(event:ProgressEvent):void
		{
			// TODO Auto-generated method stub
			Util.alert("socket recv data");
		}
		
		protected static function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			Util.alert("socket io error");
		}
		
		protected static function closeHandler(event:Event):void
		{
			Util.alert("socket closed");
		}
		
		protected static function connectHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			Util.alert("socket connected");
		}
		
		protected static function securityErrorHandler(event:SecurityErrorEvent):void
		{
			// TODO Auto-generated method stub
			Util.alert("security error occur");
		}
	}
}