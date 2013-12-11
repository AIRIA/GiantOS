package com.giant.nets
{
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
		
		private var packBuffer:String;
		private var packSize:Number;
		private var packRealSize:Number;
		private var packSuffixSize:Number = 0;
		private var decodeEnded:Boolean = true;
		
		
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
			var msgLen:Number = json.length;
			var prefix:String = Util.numToString(msgLen);
			socket.writeMultiByte(prefix+json+"\n","UTF-8");
			socket.flush();
		}
		
		protected function outputHandler(event:OutputProgressEvent):void
		{
			//Util.alert("send data");
		}
		
		private function decodePack(packStr:String,prefixLength:Number=4):void
		{
			if(decodeEnded){
				packSize = Number(packStr.substr(0,prefixLength))+1;
				packBuffer = packStr.substr(prefixLength,packSize);
				if(packBuffer.length == packSize){
					socket.dispatchEvent(new GiantEvent(GiantEvent.RECV_DATA,packBuffer));
					packBuffer = null;
					decodeEnded = true;
					var remainStr:String = packStr.substr(packSize+prefixLength);
					if(remainStr.length)
						decodePack(remainStr);
				}else{
					decodeEnded = false;
					packSuffixSize = packSize - packBuffer.length;
				}
			}else{
				var suffixStr:String;
				suffixStr = packStr.substr(0,packSuffixSize);
				packBuffer += suffixStr;
				if(packBuffer.length == packSize){
					socket.dispatchEvent(new GiantEvent(GiantEvent.RECV_DATA,packBuffer));
					decodeEnded = true;
					packBuffer = null;
					var lastStr:String = packStr.substr(packSuffixSize);
					if(lastStr.length)
						decodePack(remainStr);
				}else{
					decodeEnded = false;
					packSuffixSize = packSize - packBuffer.length;
				}
			}
			
		}
		
		protected function getDataHandler(event:ProgressEvent):void
		{
			var jsonStr:String = socket.readMultiByte(socket.bytesAvailable,"UTF-8");
			Util.info("[recv]"+jsonStr);
			decodePack(jsonStr);
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