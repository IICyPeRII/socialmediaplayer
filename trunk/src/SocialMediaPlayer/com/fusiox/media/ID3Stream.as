package FlexMediaPlayer.com.fusiox.media
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	[Event(Event.ID3)]
	public class ID3Stream extends URLStream
	{
		public var length:uint = 0;
		public var reader:ID3Reader = new ID3Reader();
		public var filePath:String;
		private var _close:Boolean = true;
		private var _bytes:ByteArray = new ByteArray();
		
		
		public function ID3Stream(path:String=null, close:Boolean=true):void {
			var request:URLRequest;
			request = new URLRequest(path);
			_close = close;
			if (request) { load(request); }
			filePath = path;
			addEventListener(ProgressEvent.PROGRESS, onID3Progress);
		}
		
		private function onID3Progress( e:ProgressEvent ):void {
			if (length == 0) { getID3Length(); }
			else if (bytesAvailable >= length) {
				readBytes(_bytes,10,bytesAvailable);
				if (_close) { close(); }
				reader.addEventListener(Event.ID3, onID3Loaded);
				removeEventListener(ProgressEvent.PROGRESS, onID3Progress);
				try {
					reader.load(_bytes);
				} catch(error:Error) {
					trace("Error:", error);
				}
			}
		}
		
		private function onID3Loaded( e:Event ):void {
			dispatchEvent(new Event(Event.ID3));
		}
		
		private function getID3Length():void {
			if( length == 0 && bytesAvailable >= 10) {
				readBytes(_bytes,0,10);
				try {
					if (_bytes.readUTFBytes(3).toUpperCase()=="ID3") {
						_bytes.readByte();
						_bytes.readByte(); // storing tag version
						_bytes.readByte(); // storing flags byte
						length = _bytes.readInt();
					} else { trace("error"); }
				} catch(e:Error) {
					trace("Read File Error");
				}
			}
		}
		
	}
}