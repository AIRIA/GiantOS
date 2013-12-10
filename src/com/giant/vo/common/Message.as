package com.giant.vo.common
{
	public class Message
	{
		private var _roomId:String;
		private var _type:String = "msg";
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
		 * 协议类型
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

		/**
		 * 房间号
		 */
		public function get roomId():String
		{
			return _roomId;
		}

		/**
		 * @private
		 */
		public function set roomId(value:String):void
		{
			_roomId = value;
		}

	}
}