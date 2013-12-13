package com.giant.managers
{
	import com.giant.configures.RouteDictionary;

	[Bindable]
	public class ShareManager
	{
		public static var port:Number = 9700;
		public static var roomId:String = "room_1";
		public static var clientRouteDic:RouteDictionary;
		public static var liveRouteDic:RouteDictionary;
		public static var pptList:Array = [{pageId:1,name:'name1',source:'ppts/1.jpg'},
			{pageId:2,name:'name2',source:'ppts/2.jpg'},
			{pageId:3,name:'name3',source:'ppts/3.jpg'},
			{pageId:4,name:'name4',source:'ppts/4.jpg'},
			{pageId:5,name:'name5',source:'ppts/5.jpg'},
			{pageId:6,name:'name6',source:'ppts/6.jpg'},
			{pageId:7,name:'name7',source:'ppts/7.jpg'}];
	}
}