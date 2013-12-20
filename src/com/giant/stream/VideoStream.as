package com.giant.stream
{
	import com.giant.configures.RouteName;
	import com.giant.events.GiantEvent;
	import com.giant.events.RTMP;
	import com.giant.managers.EventManager;
	import com.giant.managers.ShareManager;
	import com.giant.utils.Util;
	
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import spark.components.Application;

	public class VideoStream
	{
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
						appId:ShareManager.appId,
						host:host,
						streamName:ShareManager.streamName
					}));
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
		}
		
		public function publishVideo():void
		{
			netCon.connect("rtmp://"+host+"/ccsrc");
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
				h264Settings.setMode(480,320,30);
				h264Settings.setQuality(1024*500,0);
				h264Settings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_3_1);
				netStream.videoStreamSettings = h264Settings;
				netStream.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				netStream.attachCamera(client.camera);
				netStream.attachAudio(client.mic);
				netStream.publish(streamName,"live");
				video.attachCamera(client.camera);
			}
		}
		
		public function pausePublish():void
		{
			
		}
	}
}