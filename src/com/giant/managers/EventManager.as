package com.giant.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class EventManager extends EventDispatcher 
	{
		private var data:Object;
		private static var _instance:EventManager;
		public static function instance():EventManager
		{
			if(!_instance)
			{
				_instance = new EventManager();
			}
			return _instance;
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			// TODO Auto Generated method stub
			return super.dispatchEvent(event);
		}
	}
}