package com.giant.events
{
	import flash.events.Event;
	
	public class GiantEvent extends Event
	{
		/**
		 * 服务器连接成功
		 */
		public static const SERVER_CONNECTED:String = "server_connected";
		/**
		 * 服务器返回数据 
		 */		
		public static const RECV_DATA:String = "recv_data";
		/**
		 * 获取到房间信息
		 */
		public static const GET_ROOM_INFO:String = "get_room_info";
		/**
		 * 关闭服务器连接
		 */
		public static const CLOSE_CONNECT:String = "close_connect";
		
		public var data:Object;
		
		public function GiantEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}