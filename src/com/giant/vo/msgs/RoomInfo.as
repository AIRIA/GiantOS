package com.giant.vo.msgs
{
	import com.giant.vo.common.Message;
	
	public class RoomInfo extends Message
	{
		private var _student:Array

		public function get student():Array
		{
			return _student;
		}

		public function set student(value:Array):void
		{
			_student = value;
		}
	}
}