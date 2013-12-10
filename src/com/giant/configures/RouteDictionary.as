package com.giant.configures
{
	import com.giant.managers.ShareManager;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;

	/**
	 * 管理路由表
	 * 根据每条信息的route属性 来调用相应的函数句柄
	 */
	public class RouteDictionary
	{
		private var dict:Dictionary;
		
		public function RouteDictionary()
		{
			dict = new Dictionary();
		}
		
		public function clear():void
		{
			var props:Array = [];
			for(var prop:String in this){
				props.push(prop);
			}
			for(var i:int=0;i<props.length;i++)
			{
				delete this[props[i]];
			}
		}
		
		public function registerWithObj(obj:Object,recvFunc:Function):void
		{
			var route:String = getQualifiedClassName(obj);
			register(route,recvFunc);
		}
		
		public function registerWithString(route:String,recvFunc:Function):void
		{
			register(route,recvFunc);
		}
		
		private function register(route:String,recvFunc:Function):void
		{
			if(!dict.hasOwnProperty(route)){
				dict[route] = recvFunc;
			}else{
				Alert.show("发现重复的路由");
			}
		}
		
		public function recvRoute(data:String):void
		{
			var jsonObj:Object = JSON.parse(data);
			dict[jsonObj["route"]](jsonObj);
		}
	}
}