package com.giant.stream
{
	import com.giant.utils.Util;
	
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;

	/**
	 * 设置客户端摄像头和麦克风的信息
	 */
	public class Client
	{
		/**
		 * 客户端的摄像头
		 */
		public var camera:Camera;
		/**
		 * 客户端的麦克风
		 */
		public var mic:Microphone;
		
		/**
		 * 构造方法
		 * 
		 */
		public function Client()
		{
			
		}
		
		/**
		 * 返回客户端的摄像头
		 */
		private function getCamera():Camera
		{
			return camera;
		}
		
		/**
		 * 检测客户端的FlashPlayer是否支持音频和摄像头 以及是否有硬件设备
		 * 在使用摄像头和麦克风之前要首先调用此方法
		 */
		public function check():Boolean
		{
			//检测客户端摄像头的支持情况
			if(Camera.isSupported)
			{
				camera = Camera.getCamera();
				if(camera)
				{
					camera.setQuality(128*500,100);
					camera.setLoopback(false);
					camera.setMotionLevel(5,100);
					camera.setMode(960,640,30);
					camera.addEventListener(StatusEvent.STATUS,function(event:StatusEvent):void{
						var statusCode:String = event.code;
						switch(statusCode)
						{
							case "Camera.Muted":
								Util.warnTip("拒绝启动摄像头");
								break;
							case "Camera.Unmuted":
								Util.warnTip("摄像头启动");
								break;
							default:
								break;
						}
					});
				}
				else
				{
					Util.alert("没有检测到摄像头设备");
					return false;
				}
				
			}
			//检测客户端的麦克风支持情况
			if(Microphone.isSupported)
			{
				mic = Microphone.getMicrophone();
				if(mic)
				{
					mic.gain = 50; 
					mic.rate = 11;
					mic.setSilenceLevel(5,1000);
					mic.setLoopBack(false);
					mic.codec = SoundCodec.SPEEX;
					mic.encodeQuality = 6;
				}
				else
				{
					Util.warnTip("没有检测到麦克风设备");
					return false;
				}
			}
			return true;
		}
		
	}
}