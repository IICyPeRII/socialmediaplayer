package nl.fxc.fx{

	import com.aquioux.AqMath;

	public class StateDefine {
		public static var OVERALL:Number 	= 0;
		public static var CENTER:Number 	= 1;
		public static var OUTSIDE:Number 	= 2;
		public static var BOTTOM:Number 	= 3;
		public static var RIGHT:Number 		= 4;
		public static var RANDOM:Number 	= 5;
		
		// -------------------- プロパティ --------------------
		// init 起動フラグ
		private static var initFlg:Boolean = false;
										// false : 未実行、true : 既実行

		// モーション開始前の状態を定義する関数を格納する配列
		private static var function_array:Array;


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function StateDefine() {}


		// モーション開始前状態定義関数の個数を返す
		public static function get length():int {

			// init() 未実行の場合、init() を実行する
			if ( !initFlg ) { init(); }

			return function_array.length;
		}


		// 第1引数で指定した位置の関数を返す
		public static function getFunction( idx:int ):Function {

			// init() 未実行の場合、init() を実行する
			if ( !initFlg ) { init(); }

			// 第1引数が配列範囲外だった場合 0 にする
			if ( idx >= function_array.length ) { idx = 0; }

			return function_array[idx];
		}


		// 初期化
		public static function init():void {

			// フラグ立て
			initFlg = true;

			// 配列生成
			function_array = new Array();
			// 配列に関数を格納
			function_array[0] = _00;
			function_array[1] = _01;
			function_array[2] = _02;
			function_array[3] = _03;
			function_array[4] = _04;
			function_array[5] = _05;
		}
		// ---------- モーション開始前の状態を定義する関数 ----------
		//その場で
		public static function _00( objArray:Array , w:Number , h:Number ):void {
			var flg:int = AqMath.flipCoin();
			for( var idx:int=0;idx<objArray.length;idx++){
				objArray[idx].x = objArray[idx].posx;
				objArray[idx].y = objArray[idx].posy;
				/* objArray[idx].scaleX = 0;
				objArray[idx].scaleY = 0; */
				objArray[idx].rotation = AqMath.createRandomInt( 180 , -180 ) * flg;
			}
		}
		// ステージの中心から
		public static function _01( objArray:Array , w:Number , h:Number ):void {
			var flg:int = AqMath.flipCoin();
			for( var idx:int=0;idx<objArray.length;idx++){
				objArray[idx].x = w / 2;
				objArray[idx].y = h / 2;
				/*objArray[idx].scaleX = 0;
				objArray[idx].scaleY = 0; */
				objArray[idx].rotation = AqMath.createRandomInt( 180 , -180 ) * flg;
			}
		}
		// ステージを囲む円周上のランダムな位置から
		public static function _02( objArray:Array , w:Number , h:Number ):void {
			var flg:int = AqMath.flipCoin();
			for( var idx:int=0;idx<objArray.length;idx++){
				var rad:Number = AqMath.d2r( AqMath.createRandomInt( 180 , -180 ) );
				objArray[idx].x = Math.cos( rad ) * w + w/2;
				objArray[idx].y = Math.sin( rad ) * h + h/2;
				objArray[idx].rotation = AqMath.createRandomInt( 180 , -180 ) * flg;
			}
		}
		// 上 or 下
		public static function _03( objArray:Array , w:Number , h:Number ):void {
			var flg:int = AqMath.flipCoin();
			if ( flg == 0 ) { flg = -1; }
			
			for( var idx:int=0;idx<objArray.length;idx++){
				objArray[idx].x = objArray[idx].posx;
				objArray[idx].y = objArray[idx].posy + h*1.5 * flg;
				objArray[idx].rotation = 0;
			}
		}
		// 右 or 左
		public static function _04( objArray:Array , w:Number , h:Number ):void {
			var flg:int = AqMath.flipCoin();
			if ( flg == 0 ) { flg = -1; }
			for( var idx:int=0;idx<objArray.length;idx++){
				objArray[idx].x = objArray[idx].posx + w*1.5 * flg;
				objArray[idx].y = objArray[idx].posy;
				objArray[idx].rotation = 0;
			}
		}
		// ( 上 or 下 ) or ( 右 or 左 )
		public static function _05( objArray:Array , w:Number , h:Number ):void {
			var flg:int , flgx:int , flgy:int;
			
			for( var idx:int=0;idx<objArray.length;idx++){
				flg = AqMath.flipCoin();
				if ( flg == 1 ) {
					// 上下
					flgx = 0; flgy = 1;
				} else {
					// 左右
					flgx = 1; flgy = 0;
				}
				flg = AqMath.flipCoin();
				if ( flg == 0 ) { flg = -1; }
				objArray[idx].x = objArray[idx].posx + w*1.5 * flgx*flg;
				objArray[idx].y = objArray[idx].posy + h*1.5 * flgy*flg;
				objArray[idx].rotation = 0;
			}
		}
	}
}
