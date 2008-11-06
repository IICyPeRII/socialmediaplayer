package SocialMediaPlayer {
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Button;
	import mx.core.Application;
	
	public class updateManager {
		private var url:String = "http://www.villagranquiroz.cl/update-site/social-media-player.xml";
		private var url_loader:URLLoader;
		private var url_loader_air:URLLoader;
		// New Version
		private var updater_air_file:String;
		private var updater_new_version:String;
		private var updater_airFile:File;
		private var updateButton:Button;
		private var current_version:String;
		
		
		public  var can_update:Boolean = false;
		
		
		public  function set UpdateButton(btn:Button):void {
			updateButton = btn;
			updateButton.addEventListener(MouseEvent.CLICK, updateNow);
		}
		
		public function checkForUpdate():void {
			url_loader = new URLLoader();
			url_loader.addEventListener(Event.COMPLETE, loadComplete);
			url_loader.load(new URLRequest(url));
		}

		private function loadComplete(event:Event):void {
			var xml:XML = new XML(event.target.data);
			var appXML:XML = Application.application.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXML.namespace();
			current_version = appXML.ns::version;
			
			updater_air_file = String(xml.updateUrl);
			updater_new_version = String(xml.currentVersion);
			
			if(String(xml.currentVersion) != String(appXML.ns::version)) {
				can_update = true;	
				updateButton.label = "Click for update";
				updateButton.toolTip = "You can click here for update your media player to version: " + current_version + "\rFeatures:\r" + xml.updateMessage;
			} else {
				can_update = false;
				updateButton.label = "Updated";
				updateButton.toolTip = "Your current version is: " + updater_new_version;
			}
			updateButton.enabled = can_update;
			
		}
		/**
		 *	Event for update
		 */		
		public function updateNow(event:Event):void {
			updater_airFile = new File();
			updater_airFile.download(new URLRequest(updater_air_file));
			updater_airFile.addEventListener(Event.COMPLETE, updaterAIR);
		}
		private function updaterAIR(event:Event):void {
			var updater:Updater = new Updater();
			updater.update(updater_airFile, updater_new_version);
		}
	}
}



