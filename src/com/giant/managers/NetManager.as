package com.giant.managers
{
	import com.giant.configures.NetConfig;
	import com.giant.utils.Util;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * 网络通信管理类
	 */
	public class NetManager
	{
		static private var _instance:NetManager;
		
		/**
		 * 向服务器发送http请求
		 * @param url http请求地址
		 * @param param 请求中携带的参数
		 * @param handler 数据请求会来之后的回调函数的句柄
		 */
		public function send(url:String,param:Object,handler:Function):void
		{
			var urlVar:URLVariables = new URLVariables();
			for(var prop:String in param){
				urlVar[prop] = param[prop];
			}
			var urlReq:URLRequest = new URLRequest();
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,Util.info);
			urlLoader.addEventListener(Event.COMPLETE,handler);
			urlReq.url = url;
			urlReq.method = URLRequestMethod.GET;
			urlReq.data = urlVar;
			urlLoader.load(urlReq);
		}
		
		/**
		 * 获取空闲推流服务器
		 */
		public function getIdlePushServer(param:Object,handler:Function):void
		{
			send(NetConfig.PUSH_SERVER,param,function(event:Event):void{
				var urlLoader:URLLoader= event.target as URLLoader;
				urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
				handler(JSON.parse(urlLoader.data));
			});
		}
		/**
		 * 获取空闲的播流服务器的地址
		 */
		public function getIdlePlayServer(param:Object,handler:Function):void
		{
			send(NetConfig.PLAY_SERVER,param,function(event:Event):void{
				var urlLoader:URLLoader= event.target as URLLoader;
				urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
				handler(JSON.parse(urlLoader.data));
			});
		}
		
		/**
		 * 单例类
		 */
		static public function getInstance():NetManager
		{
			if(!_instance)
			{
				_instance = new NetManager();
				//VideoConfig.guid = Util.getGUID();
			}
			return _instance;
		}
	}
}