package com.fusiox.skins {
	
	import flash.display.*;
	import flash.geom.Matrix;
	import mx.skins.Border;
	import mx.controls.List;
	import com.fusiox.styles.CSSManager
	import mx.styles.StyleManager
	import mx.styles.CSSStyleDeclaration;
	
	public class CSS3Box extends mx.skins.Border {
		
		// I typically site acronym variables as a bad practice,
		// but I've made an exception due to the complex math.
		
		// new style properties
		private var _bc:Number=0xFFFFFF, _ba:Number=1;
		private var _brx:Number=0, _bry:Number=0; // border radius x:y
		private var _blw:Number=3, _brw:Number=3, _btw:Number=3, _bbw:Number=3; // border widths
		private var _blc:Number=0x000000, _brc:Number=0x000000, _btc:Number=0x000000, _bbc:Number=0x000000; // border colors
		private var _bla:Number=1, _bra:Number=1, _bta:Number=1, _bba:Number=1; // border alphas
		private var _btlrx:Number=0, _btrrx:Number=0, _bbrrx:Number=0, _bblrx:Number=0; // border radius X
		private var _btlry:Number=0, _btrry:Number=0, _bbrry:Number=0, _bblry:Number=0; // border radius Y
		private var _btlrt:Number=0, _btrrt:Number=0, _bbrrt:Number=0, _bblrt:Number=0; //border radius temporary(Y)
		//private var _bsx:Number=0, _bsy:Number=0, _bsc:Number=0, _bsa:Number=1, _bsrx:Number, _bsry:Number, _bsq:Number; // box shadow
		private var _pl:Number=0, _pr:Number=0, _pt:Number=0, _pb:Number=0; // paddings
		
		public function CSS3Box() {
			CSSManager.createProperty("borderColor","#000",new Array("borderTopColor", "borderRightColor", "borderBottomColor", "borderLeftColor"), new Array(0, -1, -2, -2));
			CSSManager.createProperty("borderWidth", "0px", new Array("borderTopWidth", "borderRightWidth", "borderBottomWidth", "borderLeftWidth"), new Array(0, -1, -2, -2));
			CSSManager.createProperty("cornerRadius", "0px", new Array("borderTopRightRadius", "borderBottomRightRadius", "borderBottomLeftRadius", "borderTopLeftRadius"), new Array(0, -1, -2, -2));
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void {
			
			if ( styleName.getStyle("borderTopColor") ) { _btc = styleName.getStyle("borderTopColor"); }
			if ( styleName.getStyle("borderRightColor") ) { _brc = styleName.getStyle("borderRightColor"); }
			if ( styleName.getStyle("borderBottomColor") ) { _bbc = styleName.getStyle("borderBottomColor"); }
			if ( styleName.getStyle("borderLeftColor") ) { _blc = styleName.getStyle("borderLeftColor"); }
			
			if ( styleName.getStyle("borderTopWidth") ) { _btw = styleName.getStyle("borderTopWidth"); }
			if ( styleName.getStyle("borderRightWidth") ) { _brw = styleName.getStyle("borderRightWidth"); }
			if ( styleName.getStyle("borderBottomWidth") ) { _bbw = styleName.getStyle("borderBottomWidth"); }
			if ( styleName.getStyle("borderLeftWidth") ) { _blw = styleName.getStyle("borderLeftWidth"); }
			
			if ( styleName.getStyle("borderTopRightRadius") ) { _btrrx = _btrry = _btrrt = styleName.getStyle("borderTopRightRadius"); }
			if ( styleName.getStyle("borderBottomRightRadius") ) { _bbrrx = _bbrry = _bbrrt = styleName.getStyle("borderBottomRightRadius"); }
			if ( styleName.getStyle("borderBottomLeftRadius") ) { _bblrx = _bblry = _bblrt = styleName.getStyle("borderBottomLeftRadius"); }
			if ( styleName.getStyle("borderTopLeftRadius") ) { _btlrx = _btlry = _btlrt = styleName.getStyle("borderTopLeftRadius"); }
			
			drawBox(w, h);
		}
		
		private function drawBox(w:Number,h:Number):void {
			var lineAlpha:Number,xx:Number,yy:Number,objXY:Object;
			graphics.clear(); // remove old background
			if (1==1) {
				// draw new background and borders
				var colors:Array;
				var alphas:Array;
				var ratios:Array;
				var matrix:Matrix; 
				
				graphics.lineStyle(0,0,0);
				
				// draw top border
				graphics.beginFill(_btc,_bta);
				graphics.moveTo(_btlrx,0);
				graphics.lineTo(w-_btrrx,0);
				graphics.lineTo(Math.min(w-_btrrx,w-_brw),_btw); // right inside
				graphics.lineTo(Math.max(_btlrx,_blw),_btw); // left inside
				graphics.lineTo(_btlrx,0); // left outside
				graphics.endFill();
				
				// draw top right curve
				if(_btrrx>0){
					colors = [_btc, _brc];
					alphas = [_bta, _bra];
					ratios = [0, 0xFF];
					matrix = new Matrix();
					matrix.createGradientBox(_btrrx, _btrrt, (45/180)*Math.PI, w-_btrrx, 0);
					graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
					graphics.moveTo(w-_btrrx,0);
					graphics.curveTo(w,0,w,_btrrt);
					graphics.lineTo(w-_brw,Math.max(_btrrt,_btw));
					graphics.curveTo(w-_brw,_btw,Math.min(w-_btrrx,w-_brw),_btw);
					graphics.lineTo(w-_btrrx,0);
					graphics.endFill();
				}
				
				// draw right border
				xx = w;
				yy = h-_bbrrt;
				graphics.beginFill(_brc,_bra);
				graphics.moveTo(xx,_btrrt); // top outside
				graphics.lineTo(xx,yy); // bottom outside
				graphics.lineTo(xx-_brw,Math.min(yy,h-_bbw));
				graphics.lineTo(xx-_brw,Math.max(_btrrt,_btw));
				graphics.lineTo(xx,_btrrt); // top outside
				graphics.endFill();
				
				
				// draw bottom right curve
				if(_bbrrx>0){
					colors = [_bbc, _brc];
					alphas = [_bba, _bra];
					ratios = [0, 0xFF];
					matrix = new Matrix();
					matrix.createGradientBox(_bbrrx, _bbrrt, (-45/180)*Math.PI, w-_bbrrx, h-_bbrrt);
					graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
					graphics.moveTo(xx,yy);
					graphics.curveTo(w,h,w-_bbrrx,h);
					graphics.lineTo(Math.min(w-_bbrrx,w),h-_bbw);
					graphics.curveTo(w-_brw,h-_bbw,xx-_brw,Math.min(yy,h));
					graphics.lineTo(xx,yy);
					graphics.endFill();
				}
				
				// draw bottom border
				xx = w-_bbrrx;
				yy = h;
				graphics.beginFill(_bbc,_bba);
				graphics.moveTo(Math.max(_bblrx,_blw),yy-_bbw); // left inside
				graphics.lineTo(Math.min(xx,w-_brw),yy-_bbw); // right inside
				graphics.lineTo(xx,yy); // right outside
				graphics.lineTo(_bblrx,yy); // left outside
				graphics.lineTo(Math.max(_bblrx,_blw),yy-_bbw); // left inside
				graphics.endFill();
				
				// draw bottom left curve
				if(_bblrx>0){
					colors = [_blc, _bbc];
					alphas = [_bla, _bba];
					ratios = [0, 0xFF];
					matrix = new Matrix();
					matrix.createGradientBox(_bblrx, _bblrt, (45/180)*Math.PI, 0, h-_bblrt); 
					graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
					graphics.moveTo(_bblrx,yy);
					graphics.curveTo(0,h,0,yy-_bblrt);
					graphics.lineTo(_blw,Math.min(h-_bblrt,_btw+_pt+h+_pb));
					graphics.curveTo(_blw,h-_bbw,Math.max(_bblrx,_blw),yy-_bbw);
					graphics.lineTo(_bblrx,yy);
					graphics.endFill();
				}
				
				// draw left border
				xx = 0;
				yy = h-_bblrt;
				graphics.beginFill(_blc,_bla);
				graphics.moveTo(xx,_btlrt); // top outside
				graphics.lineTo(xx+_blw,Math.max(_btlrt,_btw)); // top inside
				graphics.lineTo(xx+_blw,Math.min(yy,h-_bbw)); // bottom inside
				graphics.lineTo(xx,yy); // bottom outside
				graphics.lineTo(xx,_btlrt); // top outside
				graphics.endFill();
				
				// draw top left curve
				if(_btlrx>0){
					colors = [_blc, _btc];
					alphas = [_bla, _bta];
					ratios = [0, 0xFF];
					matrix = new Matrix();
					matrix.createGradientBox(_btlrx, _btlrt, (-45/180)*Math.PI, 0, 0); 
					graphics.beginGradientFill("linear", colors, alphas, ratios, matrix);
					graphics.moveTo(0,_btlrt);
					graphics.curveTo(0,0,_btlrx,0);
					graphics.lineTo(Math.max(_btlrx,_blw),_btw);
					graphics.curveTo(_blw,_btw,_blw,Math.max(_btlrt,_btw));
					graphics.lineTo(0,_btlrt);
					graphics.endFill();
				}
				
				// draw inside boundries
				graphics.beginFill(_bc,_ba);
				graphics.moveTo(_blw+_btlrx,_btw); // top left
				graphics.lineStyle(0,0,0);
				//beginFill(bc,0);
				
				//top right
				xx = w-_brw;
				yy = _btw;
				graphics.lineTo(xx-_btrrx,yy); // top right
				if(_btrrx>0){graphics.curveTo(xx,yy,xx,yy+_btrrt)};
				
				// bottom right
				xx = w-_brw;
				yy = h-_bbw;
				graphics.lineTo(xx,yy-_bbrrt);
				if(_bbrrx>0){graphics.curveTo(xx,yy,xx-_bbrrx,yy)};
				
				// bottom left
				xx = _blw;
				yy = h-_bbw;
				graphics.lineTo(xx+_bblrx,yy); 
				if(_bblrx>0){graphics.curveTo(xx,yy,xx,yy-_bblrt)};
				
				// top left
				xx = _blw;
				yy = _btw;
				graphics.lineTo(xx,yy+_btlrt);
				if(_btlrx>0){graphics.curveTo(xx,yy,xx+_btlrx,yy)};
				
				graphics.endFill();
				//drawShadow();
			}
		}
		
	}
}