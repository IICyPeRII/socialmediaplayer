package SocialMediaPlayer.networks
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class Twitter
	{
		private var update_url:String = "http://www.villagranquiroz.cl/twitter_endpoint.php";
		private var userConfigured:Boolean = false;
		
		private var user:String = "";
		private var password:String = "";
		
		public function setStatus(status:String):void {
			if(userConfigured) {
				var url:String = update_url+"?user="+user+"&password="+password+"&status="+escape(status);
				var request:URLRequest = new URLRequest(url);
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, function(event:Event):void {
					Application.application.notification.clear();
				    Application.application.notification.addTextNotificationByParams("Social Media Player", 
				       																	"You tweet is:\r" + status);
				       
				       																	
				});
				loader.load(request);
			} else {
				Alert.show("User Account not configured");
			}
		}
		
		public function setAuth(u:String, p:String):void {
			user = u;
			password = p;
			userConfigured = true;
		}
	}
}