package com.giant.managers
{
	import com.giant.configures.RouteDictionary;
	import com.giant.nets.SocketClient;
	import com.giant.utils.Util;

	[Bindable]
	public class ShareManager
	{
		public static var client:SocketClient;
		public static var port:Number = 9700;
		public static var clientRouteDic:RouteDictionary;
		public static var liveRouteDic:RouteDictionary;
		public static var pptList:Array = [];
		public static var streamName:String;
		public static var rtmpHost:String;
		public static var clientId:String = Util.getGUID();
		public static var connected:Boolean = false;
		public static var isPublish:Boolean = false;
		
	}
}