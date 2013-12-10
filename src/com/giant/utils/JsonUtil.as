package com.giant.utils
{
	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
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
		
		public static function jsonToObj(object:Object, clazz:Class):*
		{
				var bytes:ByteArray = new ByteArray();
				bytes.objectEncoding = ObjectEncoding.AMF0;
				var objBytes:ByteArray = new ByteArray();
				objBytes.objectEncoding = ObjectEncoding.AMF0;
				objBytes.writeObject( object );
				var typeInfo:XML = describeType( clazz );
				var fullyQualifiedName:String = typeInfo.@name.toString().replace( /::/, "." );
				registerClassAlias( fullyQualifiedName, clazz );
				var len:int = fullyQualifiedName.length;
				bytes.writeByte( 0x10 );
				bytes.writeUTF( fullyQualifiedName );
				bytes.writeBytes( objBytes, 1 );
				bytes.position = 0;
				var result:* = bytes.readObject();
				return result;
		}
	}
}