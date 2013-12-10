package com.giant.vo.common
{
	public class Command
	{
		/**
		 * 协议类型 是命令还是消息 cmd命令 msg消息
		 */
		public var type:String = "cmd";
		/**
		 * 路由 使用类的全限定类名作为唯一标识 
		 */		
		public var route:String;
	}
}