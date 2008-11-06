
import flash.filters.BlurFilter;
import flash.geom.Point;

import mx.collections.ArrayCollection;
import mx.core.Application;
private var colors:ArrayCollection = new ArrayCollection();


private function init():void {
	ColorsInit();
	//VisualizationColorChange();
}
private function ColorsInit():void {
	colors.addItem(0xFF0000);
	colors.addItem(0x00FF00);
	colors.addItem(0x0000FF);
	colors.addItem(0x000000);
	//VisualizationColorChange();
	/*visualization.bitmapData.applyFilter(visualization.bitmapData, visualization.bitmapData.rect, 
										 new Point(0, 0), new BlurFilter(20, 20));
	*/
}

// Para visualizacion
private function verticalBlur( e:Event ):void {
   e.target.bitmapData.applyFilter( e.target.bitmapData, e.target.bitmapData.rect, new Point(0,0), new BlurFilter(0,15));
}
   
private function horizontalBlur( e:Event ):void {
   e.target.bitmapData.applyFilter( e.target.bitmapData, e.target.bitmapData.rect, new Point(0,0), new BlurFilter(15,0));
}
   
private function verticalScroll( e:Event ):void {
   e.target.bitmapData.scroll(0,5);
}
   
private function horizontalScroll( e:Event ):void {
   e.target.bitmapData.scroll(-5,0);
}
public function VisualizationColorChange():void {
	visual_eq.setStyle("audioLineColor", 0x000000);
	visual_eq.setStyle("audioFillColor", colors.getItemAt(Math.random()*colors.length-1));
}
