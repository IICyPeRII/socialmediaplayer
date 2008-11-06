package com.metaphile.id3.frames
{
	public class TXXXFrame extends Frame
	{
		
		private var _type:uint = FrameTypes.USER_DEFINED_TEXT_INFORMATION;
		override public function get type():uint {
			return _type;
		}
		
		private var _encoding:int = 0;
		public function get encoding():int {
			return _encoding;
		}
		public function set encoding( value:int ):void {
			_encoding = value;
		}
		
		private var _description:String = "";
		public function get description():String {
			return _description;
		}
		public function set description( value:String ):void {
			_description = value;
		}
		
		private var _text:String = "";
		public function get text():String {
			return _text;
		}
		public function set text( value:String ):void {
			_text = value;
		}
		
	}
}