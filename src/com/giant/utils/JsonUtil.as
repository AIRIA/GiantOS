package com.giant.utils
{
	import mx.utils.ObjectUtil;
	
	import avmplus.getQualifiedClassName;

	/**
	 * json和object互相转换
	 */
	public class JsonUtil
	{
		/**
		 * 对象转换成json字符串
		 */
		public static function objToJson(obj:Object):String
		{
			var props:Array = ObjectUtil.getClassInfo(obj).properties as Array;
			var vo:Object = {};
			for(var i:Number=0;i<props.length;i++)
			{
				var prop:String = props[i];
				vo[prop] = obj[prop];
			}
			vo["route"] = getQualifiedClassName(obj);
			var jsonStr:String = JSON.stringify(vo);
			return jsonStr;
		}
	}
}