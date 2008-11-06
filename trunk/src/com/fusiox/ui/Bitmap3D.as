package com.fusiox.ui {
	
	import mx.core.UIComponent;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public dynamic class Bitmap3D extends UIComponent
	{	
		private var _nativeData:BitmapData;
		private var _quality:uint = 80;
		private var _pixelSize:uint = 4;
		private var _nativeWidth:uint = 0;
		private var _nativeHeight:uint = 0;
		private var _depths:Array = new Array(); // depth values
		private var _bitmapData:BitmapData = new BitmapData(1,1,true,0x00000000);
		private var _bitmap:Bitmap = new Bitmap(_bitmapData);
		
		// 3D engine variables
		private var _xa:Number = (0/180) * Math.PI; // x angle
		private var _ya:Number = (0/180) * Math.PI; // y angle
		private var _xc:Number = 500/2; // x center
		private var _yc:Number = 377/2; // y center
		private var _zc:Number = 0; // z center
		private var _fl:Number = 500; // focal length
		private var _cosy:Number = Math.cos(_ya);
		private var _siny:Number = Math.sin(_ya);
		private var _cosx:Number = Math.cos(_xa);
		private var _sinx:Number = Math.sin(_xa);
		
		public function get nativeData():BitmapData {return _nativeData};
		public function set nativeData(data:BitmapData):void {
			_nativeData = data.clone();
			_nativeWidth = _nativeData.width;
			_nativeHeight = _nativeData.height;
			super.width = _nativeWidth;
			super.height = _nativeHeight;
			_xc = _nativeWidth/2;
			_yc = _nativeHeight/2;
			_depths = new Array(Math.round(_nativeWidth/_pixelSize));
			for (var i:uint=0; i<_nativeWidth; i+=_pixelSize) {
				_depths[i] = new Array(_nativeHeight);
				for (var j:uint=0; j<_nativeHeight; j+=_pixelSize) {
					_depths[i][j] = 0;
				}
			}
		}
		
		public function get quality():uint {return _quality};
		public function set quality(value:uint):void {
			_quality = value;
			_pixelSize = Math.ceil(100/value);
			_depths = new Array(Math.round(_nativeWidth/_pixelSize));
			
			for (var i:uint=0; i<_nativeWidth; i+=_pixelSize) {
				_depths[i] = new Array(_nativeData.height);
				for (var j:uint=0; j<_nativeHeight; j+=_pixelSize) {
					_depths[i][j] = 0;
				}
			}
			
		}
		
		public function get virtualWidth():uint {return Math.round(_nativeWidth/_pixelSize)};
		public function get virtualHeight():uint {return Math.round(_nativeHeight/_pixelSize)};
		
		public function getColor(x:uint,y:uint):Number {return _nativeData.getPixel(x*_pixelSize,y*_pixelSize)};
		
		public function setPixelZ(x:int,y:int,z:int):void {
			try{
			_depths[x*_pixelSize][y*_pixelSize] = z;
			} catch(e:Error){};
		}
		
		public function get angleX():Number {return (_xa/Math.PI)*180};
		public function set angleX(value:Number):void{
			_xa = (value/180) * Math.PI;
		}
		
		public function get angleY():Number {return (_ya/Math.PI)*180};
		public function set angleY(value:Number):void{
			_ya = (value/180) * Math.PI;
		}
		
		public function Bitmap3D(data:BitmapData=null)
		{
			data ? nativeData = data : 0;
		}
		
		override protected function childrenCreated():void {
			addChild(_bitmap);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if(unscaledWidth>0 && unscaledHeight>0) {
				_bitmapData = new BitmapData(unscaledWidth, unscaledHeight, true, 0x00000000);
				_bitmap.bitmapData.dispose();
				_bitmap.bitmapData = _bitmapData;
			}
			draw();
		}
		
		public function draw():void {

			// recalculate angle
			_cosy = Math.cos(_ya);
			_siny = Math.sin(_ya);
			_cosx = Math.cos(_xa);
			_sinx = Math.sin(_xa); 
   	
   			// render frame
   			var temp:Array = new Array();
   			var c:uint = 0;
			//this.graphics.clear();			
			for (var i:uint=0; i<_nativeWidth-_pixelSize; i+=_pixelSize) {
				for (var j:uint=0; j<_nativeHeight-_pixelSize; j+=_pixelSize) {
					var col:uint = _nativeData.getPixel(i, j);
					
					var vx:Number = i-_xc;
					var vy:Number = j-_yc;
					
					var x1:Number = vx * _cosy - (_depths[i][j]+_zc) * _siny;
					var z1:Number = (_depths[i][j]+_zc) * _cosy + vx * _siny;
					var y1:Number = vy * _cosx - z1 * _sinx;
					var z2:Number = z1 * _cosx + vy * _sinx;
					var scale:Number = _fl/(_fl + z2 + _zc);
					
					temp[c] = {x:x1, y:y1, z:z2, c:col};
					c++;
				}
			}
			
			_bitmapData.fillRect( _bitmapData.rect, 0x00000000);
			temp.sortOn(["z"],[Array.NUMERIC]);
			for(var s:Number = temp.length-1; s >= 0 ; s--) {
				var scale:Number = _fl/(_fl + temp[s].z + _zc);
                _bitmapData.fillRect( new Rectangle(temp[s].x*scale+_xc, temp[s].y*scale+_yc, _pixelSize*scale*1.5, _pixelSize*scale*1.5), 0xFF000000 | temp[s].c);
			}
		}
	}
}