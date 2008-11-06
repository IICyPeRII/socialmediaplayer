package com.fusiox.ui {
	
	import com.fusiox.ui.Bitmap3D;
	import flash.events.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.system.LoaderContext;

	public class Pixel3D extends Bitmap3D {
		
		private var _loader:Loader = new Loader();
		
		public function Pixel3D(data:BitmapData=null)
		{
			data ? nativeData = data : 0;
			//_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
		}
		
		public function set source(url:String):void {
			var context:LoaderContext = new LoaderContext(true);
			_loader.load(new URLRequest(url), context);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
		}
		
		private function loaded(event:Event):void {
			super.nativeData = Bitmap(_loader.content).bitmapData;
			quality = super.quality;
			super.draw();
		}
		
		public override function set nativeData(data:BitmapData):void {
			super.nativeData = data;
			quality = super.quality;
		}
		
		public override function set quality(value:uint):void {
			super.quality = value;
			for(var x:uint=0; x<super.virtualWidth; x++) {
				for(var y:uint=0; y<super.virtualHeight; y++) {
					super.setPixelZ(x,y,Math.round(1-(super.getColor(x,y)/Number(0xFFFFFF))*100));
				}
			}
		}
		
	}
}