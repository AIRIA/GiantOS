package com.giant.vo.msgs
{
	import com.giant.vo.common.Message;

	[Bindable]
	public class PPTItem extends Message
	{
		private var _pageId:Number;
		private var _source:String;
		private var _name:String;
		
		public function PPTItem(){
			type = "ppt";
		}

		public function get pageId():Number
		{
			return _pageId;
		}

		public function set pageId(value:Number):void
		{
			_pageId = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get source():String
		{
			return _source;
		}

		public function set source(value:String):void
		{
			_source = value;
		}


	}
}