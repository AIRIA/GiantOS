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
		public static var pptList:Array = [{name:'name1',source:'ppts/1.jpg'},
			{name:'name2',source:'ppts/2.jpg'},
			{name:'name3',source:'ppts/3.jpg'},
			{name:'name4',source:'ppts/4.jpg'},
			{name:'name5',source:'ppts/5.jpg'},
			{name:'name6',source:'ppts/6.jpg'},
			{name:'name7',source:'ppts/7.jpg'}];
	}
}