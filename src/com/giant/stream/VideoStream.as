package com.giant.stream
{
	import com.giant.configures.RouteName;
	import com.giant.events.GiantEvent;
	import com.giant.events.RTMP;
	import com.giant.managers.EventManager;
	import com.giant.managers.NetManager;
	import com.giant.managers.ShareManager;
	import com.giant.utils.Util;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class VideoStream
	{
		private var connectServerTime:Number;
		private var playVideoTime:Number;
		
		private var netCon:NetConnection;
		private var netStream:NetStream;
		private var mic:Microphone;
		private var camera:Camera;
		private var onConnect:Function;
		private var client:Client;
		private var host:String;
		private var streamName:String;
		private var video:Video;
		private var h264Settings:H264VideoStreamSettings;
		private var reconnectTimer:Timer;
		
		public static function create(video:Video,host:String,streamName:String):VideoStream
		{
			return new VideoStream(video,host,streamName);
		}
		public function VideoStream(video:Video,host:String,streamName:String)
		{
			this.video = video;
			this.host = host;
			this.streamName = streamName;
			netCon = new NetConnection();
			netCon.client = {};
			netCon.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			netCon.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityHandler);
			netCon.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		protected function securityHandler(event:SecurityErrorEvent):void
		{
			
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			
		}
		
		/**
		 * 断开服务器连接后重新连接
		 */
		public function reconnect(event:Event=null):void{
			Util.info("重新尝试连接......");
			reconnectTimer = new Timer(5000,1);
			reconnectTimer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			reconnectTimer.start();
		}
		
		protected function onTimerHandler(event:TimerEvent):void
		{
			netCon.connect("rtmp://"+host+"/ccsrc");
		}
		
		protected function statusHandler(event:NetStatusEvent):void
		{
			var code:String = event.info.code;
			switch(code){
				case "NetConnection.Connect.Success":
					Util.info("RTMP服务器连接成功");
					onConnect();
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
					reconnect();
					NetManager.getInstance().sendLog({
						status:3,
						des:'Connect.Failed reconnect',
						host:host,
						streamName:streamName
					});
					EventManager.instance().dispatchEvent(new GiantEvent(RTMP.CONNECT_FAILED));
					break;
				case "NetStream.Play.PublishNotify":
					Util.info("发布开始，信息已经发送到所有订阅者");
					break;
				case "NetStream.Play.UnpublishNotify":
					Util.info("直播发布结束或服务器终止直播");
					break;
				case "NetStream.Publish.Start":
					Util.info("直播流成功开始发布");
					ShareManager.client.sendMsg(JSON.stringify({
						route:RouteName.WATCH_VIDEO,
						type:'msg',
						clientId:ShareManager.clientId,
						host:host,
						streamName:ShareManager.streamName
					}));
					break;
				case "NetStream.Play.Start":
					playVideoTime = getTimer();
					Util.info("播放开始");
					NetManager.getInstance().sendLog({
						status:7,
						des:'Play.Start',
						host:host,
						time:playVideoTime-connectServerTime,
						streamName:streamName
					});
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
		
		public function watchVideo():void
		{
			netCon.connect("rtmp://"+host+"/ccsrc");
			onConnect = watch;
		}
		
		private function watch():void
		{
			netStream = new NetStream(netCon);
			netStream.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			video.attachNetStream(netStream);
			netStream.play(streamName);
			connectServerTime = getTimer();
		}
		
		public function publishVideo():void
		{
			netCon.connect("rtmp://"+host+"/ccsrc");
			ShareManager.rtmpHost = host;
			onConnect = publish;
		}
		
		private function publish():void
		{
			client = new Client();
			var res:Boolean = client.check();
			if(res)
			{
				netStream = new NetStream(netCon);
				h264Settings = new H264VideoStreamSettings();
				h264Settings.setMode(960,640,30);
				h264Settings.setQuality(0,100);
				h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
				netStream.videoStreamSettings = h264Settings;
				netStream.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				netStream.attachCamera(client.camera);
				netStream.attachAudio(client.mic);
				netStream.publish(streamName,"live");
				video.attachCamera(client.camera);
				ShareManager.isPublish = true;
			}
		}
		
		public function end():void
		{
			netCon.close();
			netStream.close();
			Util.warnTip("直播结束！");
			if(video)
			{
				video.attachCamera(null);
				netStream.attachAudio(null);
				video.clear();
				ShareManager.isPublish = false;
			}
		}
	}
}