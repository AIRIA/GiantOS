package com.giant.managers
{
	import com.giant.configures.RouteDictionary;

	[Bindable]
	public class ShareManager
	{
		public static var port:Number = 9700;
		public static var roomId:String = "room_1";
		public static var clientRouteDic:RouteDictionary = new RouteDictionary();
		public static var liveRouteDic:RouteDictionary = new RouteDictionary();
	}
}