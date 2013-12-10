package com.giant.vo.msgs
{
	import com.giant.utils.Util;
	import com.giant.vo.common.Message;

	[Bindable]
	public class Person extends Message
	{
		/* 角色姓名 */
		public static var name:String = new Date().time.toString();
		/* ID */
		public static var id:String = Util.getGUID();
	}
}