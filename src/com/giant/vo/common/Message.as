package com.giant.vo.common
{
	public class Message
	{
		/**
		 * 房间号
		 */
		public var roomId:String;
		/**
		 * 协议类型
		 */
		public var type:String = "msg";
		/**
		 * 路由 使用类的全限定类名作为唯一标识 
		 */
		public var route:String;
	}
}