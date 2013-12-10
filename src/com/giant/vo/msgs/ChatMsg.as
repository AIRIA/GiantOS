package com.giant.vo.msgs
{
	import com.giant.vo.common.Message;

	[Bindable]
	/**
	 * 聊天记录
	 */
	public class ChatMsg extends Message
	{
		/**
		 * 发送时间 
		 */		
		public var time:String;
		/**
		 * 发送者 
		 */		
		public var human:String;
		/**
		 * 发送的内容 
		 */		
		public var content:String;
		/**
		 * 发送结果 成功还是失败 
		 */		
		public var res:String;
	}
}