package com.giant.nets
{
	import com.giant.configures.NetConfig;
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
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import avmplus.getQualifiedClassName;

	public class SocketClient
	{
		private var socket:Socket;
		private var packSize:Number = 0;
		
		public function SocketClient()
		{
			Security.loadPolicyFile("xmlsocket://"+NetConfig.CROSSDOMAIN_IP);
			socket = new Socket();
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			socket.addEventListener(Event.CONNECT,connectHandler);
			socket.addEventListener(Event.CLOSE,closeHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA,getDataHandler);
			socket.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,outputHandler);
			socket.connect(NetConfig.SERVER_IP,ShareManager.port);
			Util.info("[Socket Server IP]"+NetConfig.SERVER_IP+":"+ShareManager.port,"red");
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
			if(socket){
				if(json){
					("send data:"+json);
					var byteArray:ByteArray = new ByteArray();
					byteArray.writeMultiByte(json,"UTF-8");
					socket.writeInt(byteArray.length);
					socket.writeBytes(byteArray);
					socket.flush();
				}
			}else{
				Alert.show("您已经断开和服务器的连接 无法发送数据");
			}
		}
		
		protected function outputHandler(event:OutputProgressEvent):void
		{
			//Util.alert("send data");
		}
		
		protected function getDataHandler(event:ProgressEvent):void
		{
			try{
				while(true){
					if (packSize == 0)
					{
						if (socket.bytesAvailable < 4) 
							return;
						packSize = socket.readInt();
					}
					if (socket.bytesAvailable < packSize) 
						return;
					var data:String = socket.readMultiByte(packSize,"UTF-8");
					Util.info("[recv]("+packSize+")"+data);
					if(data=="##$$")
					{
						sendMsg("$$##");
					}else{
						socket.dispatchEvent(new GiantEvent(GiantEvent.RECV_DATA,data));
					}
					packSize=0;
				}
			}catch(e:Error){
				Util.info(e.message);
			}
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