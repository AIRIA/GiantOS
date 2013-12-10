package com.giant.configures
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class RouteDictionary
	{
		private static var dict:Dictionary = new Dictionary();
		public static function registerRoute(obj:Object,recvFunc:Function):void
		{
			var route:String = getQualifiedClassName(obj);
			if(!dict.hasOwnProperty(route)){
				dict[route] = recvFunc;
			}
		}
		
		public static function recvRoute(data:String):void
		{
			var jsonObj:Object = JSON.parse(data);
			dict[jsonObj["route"]](jsonObj);
		}
	}
}