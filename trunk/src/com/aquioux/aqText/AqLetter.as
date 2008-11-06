/*
--------------------------------------------------
AqLetter
　テキストフィールドを生成し文字を表示する。
--------------------------------------------------
*/


package com.aquioux.aqText {

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;


	public class AqLetter extends Sprite {

		// -------------------- プロパティ --------------------
		// ----- 内部で生成される変数 ----------
		private var fld : TextField;	// テキストフィールド
		private var fmt : TextFormat;	// テキストフォーマット


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function AqLetter( fldHash:Object , fmtHash:Object=null ) {
			// fldHash : テキストフィールド情報
			// 			{ text:表示テキスト , autoSize:"left" , embedFonts:false , selectable:false など }
			// fmtHash : テキストフォーマット情報（フォントの情報）
			// 			{ font:フォント名 , size:サイズ , color:色 }（基本的にこの3つ）

			// テキストフィールド定義
			fld = new TextField();
			for ( var key in fldHash ) { fld[ key ] = fldHash[ key ]; }
			addChild( fld );

			// テキストフォーマット定義
			if ( fmtHash != null ) {
				fmt = new TextFormat();
				for ( var key in fmtHash ) { fmt[ key ] = fmtHash[ key ]; }
				fld.setTextFormat( fmt );
			}
		}

		// テキストフォーマット要素（フォントの情報）の変更
		public function resetFmt( fmtHash:Object ):void {

			for ( var key in fmtHash ) { fmt[ key ] = fmtHash[ key ]; }
			fld.setTextFormat( fmt );	// テキストフォーマットを改めて適用
		}
		// 表示テキスト以外のテキストフィールド情報は、
		// 途中で変更する可能性があまりないと思われるので、
		// テキストフィールド要素を変更する関数 resetFld() は特に用意しない。
		// 表示テキストの変更はセッターで処理する


		// ゲッター
		// 表示文字
		public function get text():String		{ return fld.text; }
		// 文字領域の幅
		public function get textWidth():Number	{ return fld.textWidth; }
		// 文字領域の高
		public function get textHeight():Number	{ return fld.textHeight; }


		// セッター
		// 表示文字
		public function set text( text:String ):void {

			fld.text = text;
			fld.setTextFormat( fmt );
		}
	}
}
