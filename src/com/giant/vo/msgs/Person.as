package com.giant.vo.msgs
{
	import com.giant.vo.common.Message;

	[Bindable]
	public class Person extends Message
	{
		
		private static var _instance:Person;
		public static function getPerson():Person
		{
			if(!_instance){
				_instance = new Person();
			}
			return _instance;
		}
		
		/* 角色姓名 */
		private var _name:String = "陈老师";
		/* ID */
		private var _id:String;


		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

	}
}