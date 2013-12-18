package com.giant.managers
{
	import com.giant.configures.RouteDictionary;
	import com.giant.nets.SocketClient;

	[Bindable]
	public class ShareManager
	{
		public static var client:SocketClient;
		public static var port:Number = 9700;
		public static var roomId:String = "room_1";
		public static var clientRouteDic:RouteDictionary;
		public static var liveRouteDic:RouteDictionary;
		public static var pptList:Array = [];
	}
}