package com.giant.stream
{
	import com.giant.configures.RouteName;
	import com.giant.events.GiantEvent;
	import com.giant.events.RTMP;
	import com.giant.managers.EventManager;
	import com.giant.managers.ShareManager;
	import com.giant.utils.Util;
	import com.giant.vo.msgs.Person;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class SoundStream
	{	
		private var mic:Microphone;
		private var netCon:NetConnection;
		private var netStream:NetStream;
		private var onConnect:Function;
		private var listenData:Object;
		
		public function SoundStream()
		{
			netCon = new NetConnection();
			netCon.addEventListener(NetStatusEvent.NET_STATUS,statusEventHandler);
			netCon.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			netCon.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityHandler);
			netCon.client = {};
			EventManager.instance().addEventListener(RTMP.CONNECT_SUCCESS,successHandler);
			EventManager.instance().addEventListener(RTMP.CONNECT_FAILED,failedHandler);
			EventManager.instance().addEventListener(RTMP.VOICE_UNCONNECT,unconnectHandler);
		}
		
		protected function unconnectHandler(event:Event):void
		{
			netCon.close();
			netStream.close();
			Util.warnTip("提问结束");
			EventManager.instance().removeEventListener(RTMP.VOICE_UNCONNECT,unconnectHandler);
		}
		
		protected function successHandler(event:Event):void
		{
			onConnect(event);
			EventManager.instance().removeEventListener(RTMP.CONNECT_SUCCESS,successHandler);
		}
		
		protected function failedHandler(event:Event):void
		{
			Util.warnTip("语音服务器连接失败！");
			EventManager.instance().removeEventListener(RTMP.CONNECT_FAILED,failedHandler);
		}
		protected function listenStream(event:Event):void
		{
			netStream = new NetStream(netCon);
			netStream.addEventListener(NetStatusEvent.NET_STATUS,statusEventHandler);
			netStream.play(listenData.channelId);
		}
		
		protected function publishStream(event:Event):void
		{
			var guid:String = Util.getGUID();
			mic = Microphone.getMicrophone();
			if(mic)
			{
				mic.gain = 30; 
				mic.rate = 11;
				mic.setSilenceLevel(5,1000);
				mic.setLoopBack(false);
				mic.codec = SoundCodec.SPEEX;
				mic.encodeQuality = 6;
			}
			Util.warnTip("服务器连接成功，开始提问吧！");
			EventManager.instance().dispatchEvent(new Event(RTMP.VOICE_CONNECT));
			netStream = new NetStream(netCon);
			netStream.addEventListener(NetStatusEvent.NET_STATUS,statusEventHandler);
			netStream.client = this;
			netStream.attachAudio(mic);
			netStream.publish(guid,"live");
			var person:Person = Person.getPerson();
			var param:Object = {
				route:RouteName.LISTEN_ASK,
				channelId:guid,
				type:"msg",
				id:person.id
			};
			ShareManager.client.sendMsg(JSON.stringify(param));
		}
		
		protected function statusEventHandler(event:NetStatusEvent):void
		{
			var code:String = event.info.code;
			switch(code){
				case "NetConnection.Connect.Success":
					Util.info("RTMP服务器连接成功");
					EventManager.instance().dispatchEvent(new GiantEvent(RTMP.CONNECT_SUCCESS));
					break;
				case "NetConnection.Connect.Rejected":
					Util.info("RTMP服务器拒绝访问");
					break;
				case "NetConnection.Connect.Closed":
					Util.info("关闭RTMP服务器连接");
					break;
				case "NetConnection.Connect.AppShutdown":
					Util.info("正在关闭服务器端应用程序");
					break;
				case "NetConnection.Connect.Failed":
					Util.info("RTMP服务器连接失败");
					EventManager.instance().dispatchEvent(new GiantEvent(RTMP.CONNECT_FAILED));
					break;
				case "NetStream.Play.PublishNotify":
					Util.info("发布开始，信息已经发送到所有订阅者");
					break;
				case "NetStream.Play.UnpublishNotify":
					Util.info("直播发布结束或服务器终止直播");
					netCon.close();
					netStream.close();
					EventManager.instance().dispatchEvent(new GiantEvent(RTMP.VOICE_UNPUBLISH));
					break;
				case "NetStream.Publish.Start":
					Util.info("直播流成功开始发布");
					break;
				case "NetStream.Play.Start":
					Util.info("播放开始");
					break;
				case "NetStream.Play.StreamNotFound":
					Util.info("无法找到播放的文件");
					break;
				case "NetStream.Buffer.Empty":
					Util.info("视频流缓冲");
					break;
				case "NetStream.Buffer.Full":
					Util.info("缓冲完成");
					break;
				case "NetStream.Publish.BadName":
					Util.error("即将要发布的直播流已经存在!");
					break;
				case "NetStream.Play.Stop":
					Util.error("播放结束");
					break;
				case "NetStream.Play.Failed":
					Util.error("播放发生意外");
					break;
				default:
					break;
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function securityHandler(event:SecurityErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		public static function create():SoundStream
		{
			var	_instance:SoundStream = new SoundStream();
			return _instance;
		}
		
		public function listen(data:Object):void
		{
			netCon.connect("rtmp://192.168.1.86/live");
			onConnect = listenStream;
			Util.warnTip("开始收听发言...");
			listenData = data;
		}
		
		public function push():void
		{
			netCon.connect("rtmp://192.168.1.86/live");
			onConnect = publishStream;
			Util.warnTip("正在连接语音服务器...");
		}
	}
}