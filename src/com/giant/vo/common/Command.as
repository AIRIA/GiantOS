package com.giant.vo.common
{
	public class Command
	{
		private var _type:String = "cmd";
		private var _route:String;
		
		
		/**
		 * 路由 使用类的全限定类名作为唯一标识 
		 */
		public function get route():String
		{
			return _route;
		}

		/**
		 * @private
		 */
		public function set route(value:String):void
		{
			_route = value;
		}

		/**
		 * 协议类型 是命令还是消息 cmd命令 msg消息
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}

	}
}