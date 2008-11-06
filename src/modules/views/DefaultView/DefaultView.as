import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.events.ListEvent;



[Bindable]
private var datos:ArrayCollection = Application.application.media;;

private var path:String;

private function PlayFile():void {
	Application.application.plyr.CloseMusicFile();
	Application.application.plyr.LoadFile(path);
	Application.application.plyr.Play();
}

private function Selection(event:ListEvent):void {
	path = event.currentTarget.selectedItem.Path;
	
}
