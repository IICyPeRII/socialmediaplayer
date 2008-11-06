package SocialMediaPlayer
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class MenuManager extends EventDispatcher
	{
		public function MenuManager()
		{
		}
		public function get MenuApp():XMLList { 
			var xml:XMLList = new XMLList(<menuitem label="SMP"> 
					<menuitem label="Quit" data="quit" />
					</menuitem>);
			
			xml += FindMenus("modules/menu/", "Preferences");
			
			return xml; 
		}
		public function get MenuViews():XMLList { return FindMenus("modules/views/");}
		
		private function FindMenus(path:String, title:String=null):XMLList {
			var directory:File = File.applicationDirectory.resolvePath(path);
			var contents:Array = directory.getDirectoryListing();
			var fileStream:FileStream = new FileStream();
			var file:File;
			var xml:String;
			var configXML:XML;
			xml = "<menuitem label=\""+title+"\">"; 
			for (var i:uint = 0; i < contents.length; i++) 
			{
				if(contents[i].isDirectory) {
					fileStream.open(File.applicationDirectory.resolvePath(	path+
																contents[i].name+
																"/config.xml"	), FileMode.READ);
					configXML = new XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
					xml += "<menuitem label=\""+configXML.MenuLabel[0]+"\" data=\""+
							configXML.url[0]+"\" />";
				}
			}
			xml += "</menuitem>";
			return new XMLList(xml);
		}
	}
}