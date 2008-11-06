/*
    OrderDefine
    
    Created by Maikel Sibbald
    info@flexcoders.nl
    http://labs.flexcoders.nl
    
    Based on code found at:
    http://aquioux.blog48.fc2.com/blog-entry-204.html
    
    Just give him & me some credit
*/
package nl.fxc.fx{

	import com.aquioux.AqArray;
	import com.aquioux.AqMath;

	public class OrderDefine {

		// -------------------- プロパティ --------------------
		// init 起動フラグ
		private static var initFlg:Boolean = false;
										// false : 未実行、true : 既実行

		// モーション開始前の状態を定義する関数を格納する配列
		private static var function_array:Array;


		// -------------------- メソッド --------------------
		// コンストラクタ
		public function OrderDefine() {}


		// モーション開始順序定義関数の個数を返す
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
			function_array[0]  = _00;
			function_array[1]  = _01;
			function_array[2]  = _02;
			function_array[3]  = _03;
			function_array[4]  = _04;
			function_array[5]  = _05;
			function_array[6]  = _06;
			function_array[7]  = _07;
			function_array[8]  = _08;
			function_array[9]  = _09;
			function_array[10] = _10;
			function_array[11] = _11;
			function_array[12] = _12;
			function_array[13] = _13;
			function_array[14] = _14;
			function_array[15] = _15;
			function_array[16] = _16;
			function_array[17] = _17;
			function_array[18] = _18;
		}
		// ---------- モーション開始順を定義する関数 ----------
		// ランダム
		public static function _00( numx:uint , numy:uint ):Array {
			var order_array:Array = new AqArray();
			order_array.createNumArray( numx*numy , 3 );
			return order_array;
		}
		// 横方向（基本型）
		public static function _01( numx:uint , numy:uint ):Array {
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					order_array.push( cnty * numx + cntx );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// 縦方向
		public static function _02( numx:uint , numy:uint ):Array {
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					order_array.push( cntx * numy + cnty );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// 斜め方向（左上から）
		public static function _03( numx:uint , numy:uint ):Array {
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					order_array.push( cntx + cnty );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// 中心から（同心方形状に）
		public static function _04( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.max( Math.abs( cntx-xOff ) , Math.abs( cnty-yOff ) );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 周縁部から（同心方形状に）_04 の反転
		public static function _05( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.min( ( xOff-Math.abs( cntx-xOff ) ) , ( yOff-Math.abs( cnty-yOff ) ) );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 中心から（十字状）
		public static function _06( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.min( Math.abs( cntx-xOff ) , Math.abs( cnty-yOff ) );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 周縁部から（十字状）_06 の反転
		public static function _07( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.max( ( xOff-Math.abs( cntx-xOff ) ) , ( yOff-Math.abs( cnty-yOff ) ) );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 中心から（菱形）
		public static function _08( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.abs( cntx-xOff ) + Math.abs( cnty-yOff );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 周縁部から（菱形）_08 の反転
		public static function _09( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = ( xOff-Math.abs( cntx-xOff ) ) + ( yOff-Math.abs( cnty-yOff ) );
					order_array.push( num * 4 );
				}
			}
			return order_array;
		}
		// 蛇行（横）
		public static function _10( numx:uint , numy:uint ):Array {
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.abs( cntx-((numx-1)*(cnty%2)) ) + ( cnty * numx );
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// 蛇行（縦）
		public static function _11( numx:uint , numy:uint ):Array {
			var num:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					num = Math.abs( cnty-((numy-1)*(cntx%2)) ) + ( cntx * numy );
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// top , bottom を middle へ向けて交互に（横分割同方向）
		// _01 の分割版
		public static function _12( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var ty  : uint;
			var num : uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cnty<=yOff ? ty=cnty*2 : ty=(numy-cnty)*2-1;
					num = ty * ( numx - 1 ) + cntx + ty;
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// top , bottom を middle へ向けて交互に（横分割蛇行）
		// _10 の分割版
		public static function _13( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var ty  : uint;
			var num : uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cnty<=yOff ? ty=cnty*2 : ty=(numy-cnty)*2-1;
					num = Math.abs( cntx - ( ( numx - 1 ) * ( ty % 2 ) ) ) + ( ty * numx );
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// left , right を center へ向けて交互に（縦分割同方向）
		// _02 の分割版
		public static function _14( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var tx  : uint;
			var num : uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cntx<=xOff ? tx=cntx*2 : tx=(numx-cntx)*2-1;
					num = tx * ( numy - 1 ) + cnty + tx;
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// left , right を center へ向けて交互に（縦分割蛇行）
		// _11 の分割版
		public static function _15( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var tx  : uint;
			var num : uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cntx<=xOff ? tx=cntx*2 : tx=(numx-cntx)*2-1;
					num = Math.abs( cnty - ( ( numy - 1 ) * ( tx % 2 ) ) ) + ( tx * numy );
					order_array.push( num );
				}
			}
			if ( AqMath.flipCoin() ) { order_array.reverse(); }
			return order_array;
		}
		// 2 * 2 の 4 ブロックで上左・下右（外側から）->上右・下左（内側から）
		public static function _16( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var tx1:uint;  var ty1:uint;
			var tx2:uint;  var ty2:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cntx<xOff ? tx1=cntx*2 : tx1=(numx-cntx)*2-1;
					cnty<yOff ? ty1=cnty*2 : ty1=(numy-cnty)*2-1;
					tx2 = Math.abs( cnty - ( ( numy - 1 ) * ( tx1 % 2 ) ) );
					ty2 = Math.abs( cntx - ( ( numx - 1 ) * ( ty1 % 2 ) ) );
					order_array.push( (tx2+ty2) * 2 );
				}
			}
			return order_array;
		}
		// 2 * 2 の 4 ブロックで上右・下左（外側から）->上左・下右（内側から）
		// _16 の反転
		public static function _17( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var tx1:uint;  var ty1:uint;
			var tx2:uint;  var ty2:uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					cntx<xOff ? tx1=(numx-cntx)*2-1 : tx1=cntx*2;
					cnty<yOff ? ty1=(numy-cnty)*2-1 : ty1=cnty*2;
					tx2 = Math.abs( cnty - ( ( numy - 1 ) * ( tx1 % 2 ) ) );
					ty2 = Math.abs( cntx - ( ( numx - 1 ) * ( ty1 % 2 ) ) );
					order_array.push( (tx2+ty2) * 2 );
				}
			}
			return order_array;
		}
		// 渦
		public static function _18( numx:uint , numy:uint ):Array {
			var xOff:int = Math.floor( numx / 2 );
			var yOff:int = Math.floor( numy / 2 );
			var baseSabun : uint;  var sabun     : uint;
			var yokoSabun : uint;  var tateSabun : uint;
			var num       : uint;
			var order_array:Array = new Array();
			for( var cnty:int=0; cnty<numy; cnty++ ) {
				for( var cntx:int=0; cntx<numx; cntx++ ) {
					// ---- 上下左右判定 ----
					var s:uint = yOff - Math.abs( yOff - cnty );
					// ---- 横差分 ----
					cntx<xOff  ? yokoSabun=cntx*2+1 : yokoSabun=(numx-cntx)*2-2;
					// ---- 縦差分 ----
					cnty<=yOff ? tateSabun=cnty*2   : tateSabun=(numy-cnty)*2-1;
					if ( cntx < s ) {
						// 左
						cntx<=xOff ? num=(numy-1)-cnty : num=cnty;
						baseSabun = yokoSabun * ( numx-1 ) + yokoSabun * ( numy-1-yokoSabun );
						sabun     = baseSabun + numx + cntx;
						num += sabun;
					} else if ( cntx > numx - 1 - s ) {
						// 右
						cntx<=xOff ? num=(numy-1)-cnty : num=cnty;
						baseSabun = yokoSabun * ( numx-1 ) + yokoSabun * ( numy-1-yokoSabun );
						sabun     = baseSabun + numx + yokoSabun/2 - 1;
						num += sabun;
					} else if ( cnty <= yOff ) {
						// 上
						cnty<=yOff ? num=cntx : num=(numx-1)-cntx;
						baseSabun = tateSabun * ( numy-1 ) + tateSabun * ( numx-1-tateSabun );
						sabun     = baseSabun + cnty*3;
						num += sabun;
					} else {
						// 下
						cnty<=yOff ? num=cntx : num=(numx-1)-cntx;
						baseSabun = tateSabun * ( numy-1 ) + tateSabun * ( numx-1-tateSabun );
						sabun     = baseSabun + numy - cnty + ( tateSabun-1 );
						num += sabun;
					}
					order_array.push( num );
				}
			}
			// 反転
			if ( AqMath.flipCoin() ) {
				var d:int = ( numx*numy - 1 );
				//for ( var idx:int in order_array ) {
				for( var idx:int=0;idx<order_array.length;idx++){
					order_array[idx] = d - order_array[idx];
				}
			}
			return order_array;
		}
	}
}
