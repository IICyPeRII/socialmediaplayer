import flash.errors.IOError;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public function loadTileSimilar():void {
	var artist:String = player_controls.player_artist.text;
	var req:URLRequest = new URLRequest("http://ws.audioscrobbler.com/1.0/artist/" + artist + "/similar.xml");
	
	var url:URLLoader = new URLLoader();
	url.addEventListener(Event.COMPLETE, loadTileSimilar_listener);
	url.addEventListener(IOErrorEvent.IO_ERROR, ioError);
	url.load(req);
}
private function loadTileSimilar_listener(event:Event):void {
	var xml:XML = new XML(event.target.data);
	similar_artist.visible = false;
	similar_artist.dataProvider = null;
	similar_artist.dataProvider = xml.artist;
	appRightPanelShow.play();
	similar_artist.visible = true;
	//trace(xml.artist.toString());
} 
private function ioError(event:IOErrorEvent):void {
	appRightPanelHide.play();
	similar_artist.visible = false;
}