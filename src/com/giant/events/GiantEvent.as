package com.giant.events
{
	import flash.events.Event;
	
	public class GiantEvent extends Event
	{
		/**
		 * 服务器连接成功
		 */
		public static const SERVER_CONNECTED:String = "server_connected";
		
		private var data:Object;
		
		public function GiantEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = data;
			super(type, bubbles, cancelable);
		}
	}
}