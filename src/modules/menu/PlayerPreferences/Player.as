// ActionScript file
import SocialMediaPlayer.FileManager;
import SocialMediaPlayer.SettingsManager;

import flash.filesystem.File;

import mx.core.Application;


private var settingsMgr:SettingsManager = Application.application.settingsMgr;
private var FileMgr:FileManager = Application.application.fileMgr;

private function init():void {
	this.media_path.text = FileMgr.MediaPath;
	this.twitter_user.text = settingsMgr.twitter_user;
	this.twitter_password.text = settingsMgr.twitter_password;
	
}

private function Cancel():void {
	Application.application.ModuleLoader();
	Application.application.currentPopUp.Close();
}
private function Accept():void {
	settingsMgr.MediaPath = media_path.text;
	settingsMgr.twitter_user = twitter_user.text;
	settingsMgr.twitter_password = twitter_password.text;
	
	Application.application.Refresh();
	Application.application.ModuleLoader();
	Application.application.currentPopUp.Close();
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