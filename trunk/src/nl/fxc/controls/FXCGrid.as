/*
    FXCGrid
    
    TileList with animation
    
    version 0.02
    
    Created by Maikel Sibbald
    info@flexcoders.nl
    http://labs.flexcoders.nl

    Just give him & me some credit
*/
package nl.fxc.controls{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.TileList;
	import mx.controls.listClasses.ListBase;
	import mx.events.FlexEvent;
	
	import nl.fxc.fx.MotionEngine;
	import nl.fxc.fx.StateDefine;
	import nl.fxc.fx.holders.Cell;
	
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	public class FXCGrid extends TileList{
		public var listRenderers:Object;
		private var cells:Array;
		private var initPosition:Array  = [];
		private var delayTimeOut:Number;
		private var initAnimation:Boolean = false;
		
		private var _duration:Number 	= 2000;
		private var _delay:Number 		= 2000;
		private var _effectType:Number	= 0;
		private var _easingType:Number	= 0;
		private var _stateType:Number	= StateDefine.CENTER;
		
		private function setupGrid(event:Event = null):void{
			if(!this.initAnimation){
				this.cells = this.createCells();
				this.defaultPosition();
				MotionEngine.motion( this.cells , this.width, this.height , this.columnCount , this.rowCount , this.stateType, this.effectType, this.duration/1000, this.easingType);
				//this.initAnimation = true;
			}
		}
		
		private function createCells():Array {
			var objArray:Array = new Array();
			for( var i:int=0; i<this.listContent.numChildren; i++ ){
				var item:Object = this.listContent.getChildAt(i);
				var initX:Number = item.x;
				var initY:Number = item.y;
				
				var c:Cell = new Cell(item);
				c.posx = initX;
				c.posy = initY;
				objArray.push(c);
 			
			}
			return objArray;
		}
		
		private function defaultPosition( ):void {
			for( var idx:int=0;idx<cells.length;idx++){
				cells[idx].x = cells[idx].posx;
				cells[idx].y = cells[idx].posy;
				/* cells[idx].scaleX = 0;
				cells[idx].scaleY = 0; */
			}
		}
		
		override protected function createChildren():void{
			super.createChildren();
			this.getChildAt(0).alpha = 0;
			this.getChildAt(1).alpha = 0;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(this.initPosition.length != this.listContent.numChildren){
				this.initPosition = [];
				for( var i:int=0; i<this.listContent.numChildren; i++ ){
					var item:Object = this.listContent.getChildAt(i);
					this.initPosition.push(new Point(item.x, item.y));
				}
			}
			
			if(stage != null){
				MotionEngine.stopMotion( this.cells );
				for( var i:int=0; i<this.listContent.numChildren; i++ ){
					this.listContent.getChildAt(i).x = this.initPosition[i].x;
					this.listContent.getChildAt(i).y = this.initPosition[i].y;
				}
				
				clearTimeout(this.delayTimeOut);
				this.delayTimeOut = setTimeout(this.setupGrid, this.delay);
				this.listRenderers = this.listContent;
			}
		}
		
		public function set stateType(value:Number):void{
			this._stateType = value;
		}
		
		public function get stateType():Number{
			return this._stateType;
		}
		
		public function set effectType(value:Number):void{
			this._effectType = value;
		}
		
		public function get effectType():Number{
			return this._effectType;
		}
		
		public function set easingType(value:Number):void{
			this._easingType = value;
		}
		
		public function get easingType():Number{
			return this._easingType;
		}
		
		public function set delay(value:Number):void{
			this._delay = value;
		}
		
		public function get delay():Number{
			return this._delay;
		}
		
		public function set duration(value:Number):void{
			this._duration = value;
		}
		
		public function get duration():Number{
			return this._duration;
		}
	}
}