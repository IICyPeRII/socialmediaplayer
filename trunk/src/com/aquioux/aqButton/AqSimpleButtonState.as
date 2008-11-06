/*
--------------------------------------------------
AqSimpleButtonState
　AqSimpleButton 用ボタン状態表示オブジェクト生成クラス
--------------------------------------------------
*/


package com.aquioux.aqButton {

	import flash.display.Shape;
	import flash.display.Sprite;

	import com.aquioux.aqText.AqLetter;


	public class AqSimpleButtonState extends Sprite {

		// -------------------- プロパティ --------------------
		// 下地用プロパティ
		private var fillColor : uint    = 0x000000;
		private var fillAlpha : Number  = 1;
		private var lineFlg   : Boolean = false;
		private var lineColor : uint    = 0x000000;

		// ラベル用プロパティ
		private var text      : String  = null;
		private var textColor : uint    = 0x000000;
		// AqLetter 用プロパティ
		private var fld_hash : Object = { autoSize:"left" , selectable:false };
		private var fmt_hash : Object = { font:"_等幅" , size:12 };


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function AqSimpleButtonState(
			w : Number ,				// 幅
			h : Number ,				// 高
			baseInitObj  : Object=null ,// 下地用の initObj
			labelInitObj : Object=null	// ラベル用の initObj
		) {
			// 下地の生成
			// 下地用プロパティ確定
			if ( baseInitObj != null ) {
				// 可視
				for ( var key in baseInitObj ) { this[key] = baseInitObj[key]; }
			} else {
				// 透明
				this.fillAlpha = 0;
			}
			// 下地生成
			var base:Shape = addChild( new Shape() ) as Shape;
			// 下地塗りつぶし
			if ( this.lineFlg ) { base.graphics.lineStyle( 1 , this.lineColor ); }
			base.graphics.beginFill( this.fillColor , this.fillAlpha );
			base.graphics.drawRect( 0 , 0 , w , h );
			base.graphics.endFill();


			// ラベルの生成
			if ( labelInitObj != null ) {
				// ラベル用プロパティ確定
				for ( var key in labelInitObj ) { this[key] = labelInitObj[key]; }
				this.fld_hash.text  = this.text;
				this.fmt_hash.color = this.textColor;
				// ラベル生成
				var label:AqLetter = addChild( new AqLetter( this.fld_hash , this.fmt_hash ) ) as AqLetter;
				// ラベル位置調整
				label.x = ( w - label.width )  / 2;
				label.y = ( h - label.height ) / 2;
			}
		}
	}
}
