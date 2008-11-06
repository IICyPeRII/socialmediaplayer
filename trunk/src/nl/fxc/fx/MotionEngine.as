package nl.fxc.fx{

	import com.aquioux.AqArray;
	import com.aquioux.AqMath;

	import caurina.transitions.Tweener;

	public class MotionEngine {
	
		private static var transitions : Array = [
			"easeoutexpo"    ,
			"easeoutelastic" ,
			"easeoutback"    ,
			"easeoutbounce"
		];
	
		public static function stopMotion( objArray:Array ):void {
			if(objArray != null){
				for( var idx:int=0;idx<objArray.length;idx++){
					Tweener.removeTweens( objArray[idx] );
				}
			}
		}
		
		public static function motion( objArray:Array , w:Number , h:Number , numx:uint , numy:uint , state:Number = 0, order:Number = 0, duration:Number = 2, easingType:Number = -1):void {
			for( var idx:int=0;idx<objArray.length;idx++){
				Tweener.removeTweens( objArray[idx] );
			}

			initObjState( objArray , w , h , state);
			doObjTween( objArray , setObjOrder( numx , numy , order ), duration, easingType);
		}

		private static function initObjState( objArray:Array , w:Number , h:Number , state:Number):void {
			var idx  : int      = state;
			var func : Function = StateDefine.getFunction( idx );
			func( objArray , w , h );
		}

		private static function setObjOrder( numx:uint , numy:uint , order:Number):Array {
			var idx  : int      = order;
			var func : Function = OrderDefine.getFunction( idx );
			return func( numx , numy );
		}

		private static function doObjTween( objArray:Array, orders:Array, duration:Number = 2, easingType:Number = -1):void {
			
			var i:uint;
			if(easingType == -1){
				i = AqMath.createRandomInt( transitions.length-1 );
			}else{
				i = easingType;
			}
			
			for( var idx:int=0;idx<objArray.length;idx++){
				Tweener.addTween(
					objArray[idx] ,{
						x          : objArray[idx].posx ,
						y          : objArray[idx].posy ,
						scaleX     : 1 ,
						scaleY     : 1 ,
						rotation   : 0 ,
						time       : duration ,
						delay      : 0.075 * orders[idx] ,
						transition : transitions[i]
					}
				);
			}
		}
	}
}