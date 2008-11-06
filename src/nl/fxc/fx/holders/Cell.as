/*
    Cell
    
    Created by Maikel Sibbald
    info@flexcoders.nl
    http://labs.flexcoders.nl
    
    Based on code found at:
    http://aquioux.blog48.fc2.com/blog-entry-204.html
    
    Just give him & me some credit
*/
package nl.fxc.fx.holders{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.binding.utils.BindingUtils;


	public class Cell extends Sprite {

		// -------------------- プロパティ --------------------
		// 最初のセルの座標を (0,0) としたときの当該セルの座標
		private var px : Number = 0;
		private var py : Number = 0;

		// 当該セルの順番
		private var nx : int = 0;
		private var ny : int = 0;
		private var _renderer:Object;


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function Cell( face=null ):void {

			var f;

			if ( !face ) {
				// 指定なし
				f = new Shape();
//				f.graphics.lineStyle( 0 , 0x000000 );
				f.graphics.beginFill( 0xcc0033 , 1 );
				f.graphics.drawRect( 0 , 0 , 20 , 20 );
				f.graphics.endFill();
				addChild( f );
			} else {
				// 指定あり
				if ( face is BitmapData ) {
					// BitmapData
					f = new Bitmap( face );
					addChild( f );
				} else {
					// 表示オブジェクト
					this.renderer = face;
					f = face;
				}
			}

			f.x = -width  / 2;
			f.y = -height / 2;
		}


		// ゲッター
		// 位置
		public function get posx():Number { return px; }
		public function get posy():Number { return py; }
		// 順序
		public function get orderx():int { return nx; }
		public function get ordery():int { return ny; }
		
		public function get renderer():Object { return _renderer; }
		public function set renderer( val:Object ):void { _renderer = val; }


		// セッター
		// 位置
		public function set posx( val:Number ):void { px = val; }
		public function set posy( val:Number ):void { py = val; }
		// 順序
		public function set orderx( val:int ):void { nx = val; }
		public function set ordery( val:int ):void { ny = val; }
		
		override public function set x(value:Number):void{
			super.x = value;
			if(this.renderer != null){
				this.renderer.x = x;
			}
		}
		
		override public function set y(value:Number):void{
			super.y = value;
			if(this.renderer != null){
				this.renderer.y = super.y;
			}
		}
		
		override public function set scaleX(value:Number):void{
			if(this.renderer != null){
				this.renderer.scaleX = value;
			}
		}
		
		/* override public function get scaleX():Number{
			return this.renderer.scaleX;
		} */
		
		override public function set scaleY(value:Number):void{
			if(this.renderer != null){
				this.renderer.scaleY = value;
			}
		}
		
		/* override public function get scaleY():Number{
			return this.renderer.scaleY;
		} */
		
		override public function set rotation(value:Number):void{
			super.rotation = value;
			if(this.renderer != null){
				this.renderer.rotation = rotation;
			}
		}
		
	}
}
