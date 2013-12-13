package com.giant.utils
{
	import flash.external.ExternalInterface;
	import flash.media.Microphone;
	import flash.system.Capabilities;
	
	import mx.utils.ObjectUtil;

	/**
	 * 可以在控制台打印Log消息
	 * 可以在浏览器以alert的方式 弹出来信息 供客户端查看
	 */
	public class Util
	{
		
		/**
		 * 是否在浏览器内运行
		 */
		static private function isBrowser():Boolean
		{
			var env:String = Capabilities.playerType;
			if(["ActiveX","PlugIn"].indexOf(env)!=-1)
			{
				return true;	
			}
			return false;
		}
		
		/**
		 * 如果是嵌入在浏览器中的话 在控制台中 打印出来日志
		 */
		static public function info(msg:String):void
		{
			if(isBrowser())
			{
				ExternalInterface.call("console.log",msg);
			}
		}
		
		/**
		 * 如果是嵌入在浏览器中的话 在控制台中 打印出来错误信息
		 */
		static public function error(msg:String):void
		{
			if(isBrowser())
			{
				ExternalInterface.call("console.error",msg);
			}
		}
		
		/**
		 * 如果是嵌入在浏览器中显示的话 可以弹出模态的对话框
		 */
		static public function alert(msg:String):void
		{
			if(isBrowser())
			{
				ExternalInterface.call("alert",msg);
			}
		}
		
		
		static public function getGUID():String
		{
			var guid:String = "";
			for (var i:Number = 1; i <= 32; i++) {
				var n:String = Math.floor(Math.random() * 16.0).toString(16);
				guid += n;
				if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
					guid += "-";
			}
			return guid;
		}
		
		static public function decode(src:Object,target:Object):void
		{
			var props:Array = ObjectUtil.getClassInfo(target).properties as Array;
			var vo:Object = {};
			for(var i:Number=0;i<props.length;i++)
			{
				var prop:String = props[i];
				target[prop] = src[prop];
			}
		}
		
		static public function stringToNum(str:String):Number
		{
			return Number(str);
		}
		
		static public function numToString(num:Number,prefix:String="0",targetLength:Number=4):String
		{
			var numStr:String = num.toString();
			var len:Number = targetLength - numStr.length;
			var prefixStr:String = "";
			while(len>0){
				prefixStr += prefix;
				len--;
			}
			return prefixStr+numStr;
		}
		
		static public function supportMic():Boolean
		{
			return Microphone.names.length as Boolean;
		}
		
	}
}