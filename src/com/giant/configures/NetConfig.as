package com.giant.configures
{
	[Bindable]
	public class NetConfig
	{
		/**
		 * 策略文件的地址
		 */
		static public var CROSSDOMAIN_IP:String;
		/**
		 * socket服务器地址
		 */
		static public var SERVER_IP:String;
		static public var STU_PORT:Number;
		static public var TEA_PORT:Number;
		public static var PPT_SERVER:String;
		/**
		 * 推送服务器的地址
		 */
		static public var PUSH_SERVER:String;
		/**
		 * 播流服务器的地址
		 */
		static public var PLAY_SERVER:String;
		/**
		 * 推送成功后通知的地址
		 */
		static public var PUSH_SUCCESS:String; 
		/**
		 * 日志服务器的地址
		 */
		static public var LOG_SERVER:String;
	}
}