package com.fusiox.ui {
	
 	import flash.display.Bitmap;
 	import flash.display.BitmapData;
 	import flash.events.Event;
 	import flash.filters.BlurFilter;
 	import flash.geom.Point;
 	import flash.geom.Rectangle;
 	import flash.media.SoundMixer;
 	import flash.utils.ByteArray;
 	
 	import mx.core.UIComponent;
	
	[Event("afterVisualization")]
	[Event("beforeVisualization")]
	[Style(name="audioLineColor",type="Number",format="Color",inherit="no")]
	[Style(name="audioFillColor",type="Number",format="Color",inherit="no")]
 	public class Visualization extends UIComponent {
 		
 		public var type:String = "line"; // line, wave, bars
  		public var channel:String="mono"; // mono, left, right, stereo
  		public var bars:uint = 256;
  		
  		private var _audioLineColor:uint = 0x000000;
  		private var _audioFillColor:uint = 0x000000;
  		//private var min:uint = 0;
  		//private var max:uint = 255;
  		private var gain:uint = 1;
  		
 		private var display:UIComponent = new UIComponent();
  		public var bitmapData:BitmapData = new BitmapData(1, 1, true, 0x00000000);
  		public var bitmap:Bitmap = new Bitmap(bitmapData);
  		private var spectrumData:ByteArray = new ByteArray();
  		private var rc:Number = 0; // relativeCenter
  		private var rp:Number = 0; // relativePixel
  		
  		
  		public function Visualization() {
   			addEventListener(Event.ENTER_FRAME, enterFrameListener);
   		}
   		
   		override protected function createChildren():void {
   			//display.addChild(bitmap);
   			addChild(bitmap);
   		}
   		
   		override protected function updateDisplayList(w:Number, h:Number):void {
   			super.updateDisplayList(w, h);
   			var bt:uint = getStyle("borderThickness")*2;
   			if(w-bt>0 && h-bt>1) {bitmapData = new BitmapData(w-bt, h-bt, true, 0x0);}
   			bitmap.bitmapData = bitmapData;
   			_audioLineColor = getStyle("audioLineColor");
   			_audioFillColor = getStyle("audioFillColor");
   			// convenience variables to skip useless calls to getters
   			rc = (h-bt)/2;
   			rp = (w-bt)/256;
   		}
   		
  		private function enterFrameListener(e:Event):void {
  			var rect:Rectangle = bitmapData.rect
  			try {
   				SoundMixer.computeSpectrum(spectrumData, type=="bars", 0);
   			} catch(e) {}
			dispatchEvent( new Event("beforeVisualization",true) );
			if(!hasEventListener( "beforeVisualization" )) { bitmapData.fillRect( rect, 0x0); }
			switch (channel) {
				case "mono":
					toMono();
				case "left":
					if(type=="line" || type=="wave") { drawWave(1); }
					if(type=="wave") {
						spectrumData.position=0;
						drawWave(-1);
					}
					if(type=="bars") {
						drawEQ();
					}
					break;
				case "right":
					for (var i:int = 0; i < 256 ; i++) {spectrumData.readFloat();} // using spectrumData.position yields poor results
					if(type=="line" || type=="wave") { drawWave(1); }
					if(type=="wave") {
						spectrumData.position=0;
						for (var i:int = 0; i < 256 ; i++) {spectrumData.readFloat();}
						drawWave(-1);
					}
					if(type=="bars") {
						drawEQ();
					}
					break;
				case "stereo":
					if(type=="line" || type=="wave") {
						drawWave(1);
						drawWave(1);
					}
					if(type=="wave") {
						spectrumData.position=0;
						drawWave(-1);
						drawWave(-1);
					}
					if(type=="bars") {
						drawEQ();
						drawEQ();
					}
					break;
			}
			bitmapData.applyFilter( bitmapData, rect, new Point(0,0), new BlurFilter(bitmapData.width/256,bitmapData.width/256,1));
			dispatchEvent( new Event("afterVisualization",true) );
		}
		
		private function toMono():void {
			spectrumData.position = 0;
			if(spectrumData.length==2048) {
				var leftData:ByteArray = new ByteArray();
   				var rightData:ByteArray = new ByteArray();
   				spectrumData.readBytes(leftData, 0, 1024);
   				spectrumData.readBytes(rightData, 0, 1024);
   				spectrumData = new ByteArray();
   				for (var i:uint = 0; i < 256 ; i++) {
   					spectrumData.writeFloat((leftData.readFloat()+rightData.readFloat())/2);
   				}
   				spectrumData.position = 0;
   			}
		}
		
		/*
		private function narrowEQ():void {
			var tempData:ByteArray = new ByteArray();
			spectrumData.readBytes(tempData, 0, 1024);
			spectrumData = new ByteArray();
			var n:Number = 0;
			if(min>=max) {
				max=255;
				min=0;
			}
			for (var i:uint = 0; i < min; i++) { n = tempData.readFloat(); } // gets to min
   			for (var i:uint = 0; i <= max-min; i++) {
   				n = tempData.readFloat()
   				for (var j:uint = 0; j < Math.floor(255/max-min+1); j++) {
   					spectrumData.writeFloat(n);
   				}
   			}
   			spectrumData.position = 0;
		}
		*/
		
		private function drawWave(modifier:Number=1):void {
			var v:Number;
   			var lastv:Number = rc;
   			for (var i:uint = 0; i < 256; i++) {
			    v = rc+spectrumData.readFloat()*rc*modifier*-1;
		    	if(type=="wave"){bitmapData.fillRect( new Rectangle(i*rp, Math.min(v,rc), rp, Math.abs(rc-v)), 0xFF000000 | _audioFillColor );}
   				bitmapData.fillRect( new Rectangle(i*rp, v, rp, 1+Math.abs(lastv-v)), 0xFF000000 | _audioLineColor );
		    	lastv=v;
		    }
		}
		
		private function drawEQ():void {
			//narrowEQ();
			var v:Number;
   			var n:Number = 0;
   			var nrp:Number = rp*256/bars;
   			for (var i:uint = 0; i < bars; i++) {
   				n = 0;
	   			for (var j:uint = 0; j < Math.floor(256/bars) ; j++) {
	   				try {
						n += spectrumData.readFloat();
	   				} catch(e) {}
			    }
			    n = n/Math.floor(256/bars)
			    v = Math.max(rc*2-n*rc*2*gain,5);
			    
		    	bitmapData.fillRect( new Rectangle(nrp/8+i*nrp, v, nrp/2+nrp/4, rc*2-v), 0xFF000000 | _audioFillColor);
   				bitmapData.fillRect( new Rectangle(nrp/8+i*nrp, v, nrp/2+nrp/4, 1), 0xFF000000 | _audioLineColor );
		    }
		}
		
  	}
}