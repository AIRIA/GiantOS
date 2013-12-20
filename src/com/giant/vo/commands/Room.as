package com.giant.vo.commands
{
	import com.giant.vo.common.Command;

	[Bindable]
	public class Room extends Command
	{
		
		private static var _instance:Room;
		
		public static function getRoom():Room
		{
			if(!_instance)
			{
				_instance = new Room();
			}
			return _instance;
		}
		
		public var roomId:String;
	}
}