// ActionScript file
import SocialMediaPlayer.SQLiteConnector;

import flash.filesystem.File;

import mx.controls.Alert;
import mx.core.Application;
private var original_path:String;

private var SQLConn:SQLiteConnector = Application.application.SQLConn;

private function init():void {
	var sql:String = 
	"	SELECT	MediaPath FROM Preferences";
	original_path = SQLConn.FetchOne(sql);
	this.media_path.text = original_path;

}
private function Accept():void {
	var sql:String;
	sql = "	UPDATE 	Preferences " + 
		"	SET		MediaPath = :param1";
	SQLConn.DoSQL(sql, media_path.text);
	Application.application.fileMgr.MediaPath = media_path.text;
	Application.application.ModuleLoader();
	Alert.show("Settings saved, now you can close this window", "Settings Saved");
	if(this.media_path.text != original_path)
		Application.application.ReloadMusic();
}
private function CleanDb():void {
	var sql:String;
	sql = "DELETE FROM Media WHERE 1";
	SQLConn.DoSQL(sql);
	Alert.show("Songs Database Cleaned");
}
private function SelectPath():void {
	var directory:File = File.documentsDirectory;
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
    if(this.media_path.text != original_path)
    	info.text = "Please wait after you click on Accept (loading music...)";
}