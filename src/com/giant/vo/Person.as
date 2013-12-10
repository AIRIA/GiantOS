package com.giant.vo
{
	import com.giant.utils.Util;

	[Bindable]
	public class Person extends Protocol
	{
		/* 角色姓名 */
		public static var name:String = new Date().time.toString();
		/* ID */
		public static var id:String = Util.getGUID();
	}
}