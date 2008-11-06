/*
--------------------------------------------------
AqSimpleButton
　SimpleButton 拡張
　ボタンの各状態を示す表示オブジェクトは、
　registState クラスで作成
--------------------------------------------------
*/


package com.aquioux.aqButton {

	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
//	import flash.events.Event;


	public class AqSimpleButton extends SimpleButton {

		// -------------------- プロパティ --------------------
		// ----- 外部から読み込まれる変数 ----------
		// サイズ
		private var w : Number;			// 幅
		private var h : Number;			// 高

		// ----- 外部から参照される変数 ----------
		// 各マウスイベント対応関数用
		// 処理コードは今までのボタン同様、外部で定義する（よって public ）
		public var onPress          : Function;
		public var onRelease        : Function;
		public var onReleaseOutside : Function;
		public var onRollOver       : Function;
		public var onRollOut        : Function;


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function AqSimpleButton(
			w : Number ,
			h : Number ,
			initObjBaseUp    : Object=null ,	// upState   用 下地　の initObj
			initObjLabelUp   : Object=null ,	// upState   用 ラベルの initObj
			initObjBaseOver  : Object=null ,	// overState 用 下地　の initObj
			initObjLabelOver : Object=null ,	// overState 用 ラベルの initObj
			initObjBaseDown  : Object=null ,	// downState 用 下地　の initObj
			initObjLabelDown : Object=null  	// downState 用 ラベルの initObj
		) {
			this.w = w;
			this.h = h;

			// upState ボタン状態表示オブジェクトの登録
			var s:AqSimpleButtonState = registState( "up" , initObjBaseUp , initObjLabelUp );
			downState     = s;
			overState     = s;
			hitTestState  = s;
			useHandCursor = true;

			if ( initObjBaseOver != null ) {
				registState( "over" , initObjBaseOver , initObjLabelOver );
			}
			if ( initObjBaseDown != null ) {
				registState( "down" , initObjBaseDown , initObjLabelDown );
			}

			// ボタンアクション登録
			addEventListener( MouseEvent.MOUSE_DOWN , press );
			addEventListener( MouseEvent.ROLL_OVER  , rollOver );
			addEventListener( MouseEvent.ROLL_OUT   , rollOut );

			// 削除されたときのリスナー登録
//			addEventListener( Event.REMOVED , removeHandler );
		}


		// ボタン状態表示オブジェクトの生成と登録
		public function registState(
			state        : String ,
			initObjBase  : Object=null ,
			initObjLabel : Object=null
		):AqSimpleButtonState {

			var s:AqSimpleButtonState = new AqSimpleButtonState( this.w , this.h , initObjBase , initObjLabel );
			this[state+"State"] = s;

			return s;
		}


		// ---------- ボタンアクション ----------
		public function press( e:MouseEvent ):void {
			callEvent( onPress , e );
			setMouseUp();
		}
		// Release
		public function release( e:MouseEvent ):void {
			clearMouseUp();
			callEvent( onRelease , e );
		}
		// ReleaseOutside
		public function releaseOutside( e:MouseEvent ):void {
			clearMouseUp();
			callEvent( onReleaseOutside , e );
		}
		// RollOver
		public function rollOver( e:MouseEvent ):void {
			callEvent( onRollOver , e );
		}
		// RollOut
		public function rollOut( e:MouseEvent ):void {
			callEvent( onRollOut , e );
		}
		// マウスダウン時にボタンリリース用イベントリスナーの登録
		private function setMouseUp():void {
			addEventListener( MouseEvent.MOUSE_UP , release );
			stage.addEventListener( MouseEvent.MOUSE_UP , releaseOutside );
		}
		// マウスアップ時にボタンリリース用イベントリスナーの削除
		private function clearMouseUp():void {
			removeEventListener( MouseEvent.MOUSE_UP , release );
			stage.removeEventListener( MouseEvent.MOUSE_UP , releaseOutside );
		}

		// マウスイベントの実行
		private function callEvent( func:Function , e:MouseEvent ):void {
			if ( func is Function ) { func.apply( this , [e] ); }
		}


		// 消去
		public function kill():void {
			this.parent.removeChild( this );
		}

/*
		// SimpleButton の状態表示が切り替わるときにも Event.REMOVED が発生しているので、
		// このクラスオブジェクトが removeChild されたときの Event.REMOVED を取得できるようにするか、
		// このメソッドを捨てるか、どちらか考えること
		//
		// 削除されたときの処理（マウスイベントリスナーの消去）
		private function removeHandler( e:Event ):void {
			// このメソッドを呼び出すリスナー
			removeEventListener( Event.REMOVED , removeHandler );

			// マウスイベントリスナー
			clearMouseUp();
			removeEventListener( MouseEvent.MOUSE_DOWN , press );
			removeEventListener( MouseEvent.ROLL_OVER  , rollOver );
			removeEventListener( MouseEvent.ROLL_OUT   , rollOut );

		}
*/
	}
} 
