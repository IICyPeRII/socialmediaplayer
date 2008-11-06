// ActionScript file
import SocialMediaPlayer.SQLiteConnector;

import flash.filesystem.File;
import mx.core.Application;


private var SQLConn:SQLiteConnector = Application.application.SQLConn;

private function init():void {
	var sql:String = 
	"	SELECT	MediaPath FROM Preferences";
	this.media_path.text = SQLConn.FetchOne(sql);

}

private function Cancel():void {
	Application.application.ModuleLoader();
}
private function Accept():void {
	var sql:String;
	sql = "	UPDATE 	Preferences " + 
		"	SET		MediaPath = :param1";
	SQLConn.DoSQL(sql, media_path.text);
	Application.application.ModuleLoader();
}
private function SelectPath():void {
	var directory:File;
	if(this.media_path.text.length > 0)
		directory = new File(this.media_path.text);
	else 
		directory = File.documentsDirectory;
	try 	{
	    directory.browseForDirectory("Select your Media Path");
	    directory.addEventListener(Event.SELECT, SelectedDirectory);
	}
	catch (error:Error) {
	    trace("Failed:", error.message)
	}
}
private function SelectedDirectory(event:Event):void {
    var directory:File = event.target as File;
    this.media_path.text = directory.nativePath;
}