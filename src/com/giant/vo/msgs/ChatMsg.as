package com.giant.vo.msgs
{
	import com.giant.vo.common.Message;

	[Bindable]
	/**
	 * 聊天记录
	 */
	public class ChatMsg extends Message
	{
		private var _time:String;
		private var _human:String;
		private var _content:String;

		/**
		 * 发送的内容 
		 */
		public function get content():String
		{
			return _content;
		}

		/**
		 * @private
		 */
		public function set content(value:String):void
		{
			_content = value;
		}

		/**
		 * 发送者 
		 */
		public function get human():String
		{
			return _human;
		}

		/**
		 * @private
		 */
		public function set human(value:String):void
		{
			_human = value;
		}

		/**
		 * 发送时间 
		 */
		public function get time():String
		{
			return _time;
		}

		/**
		 * @private
		 */
		public function set time(value:String):void
		{
			_time = value;
		}

	}
}