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
		public static var appId:String = Util.getGUID();
	}
}