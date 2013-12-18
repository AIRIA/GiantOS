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
		/**
		 * 学生输入名称完毕
		 */
		public static const INPUT_NAME_ENDED:String = "input_name_ended";
		/**
		 * 学生举手抢麦
		 */
		public static const HANDS_UP:String = "hands_up";
		/**
		 * 学生登录进来
		 */
		public static const STU_LOGIN:String = "stu_login";
		/**
		 * 学生登出 
		 */		
		public static const STU_LOGOUT:String = "stu_logout";
		
		public static const SYS_WARN_INFO:String = "sys_warn_info";
		
		public static const SYS_ERROR_INFO:String = "sys_error_info";
		/**
		 * 发布视频的事件 
		 */		
		public static const PUBLISH_VIDEO:String = "publish_video";
		/**
		 * 观看视频的事件 
		 */		
		public static const WATCH_VIDEO:String = "watch_video";
		/**
		 * 获取到ppt列表的事件 
		 */		
		public static const GET_PPTLIST:String = "get_pptlist";
		
		public var data:Object;
		
		
		public function GiantEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}