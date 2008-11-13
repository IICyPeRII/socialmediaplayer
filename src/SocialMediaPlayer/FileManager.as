// GNU GPL License - 2008
//----------------------------------------------
//        Villagrán & Quiroz
//   http://www.villagranquiroz.cl
package SocialMediaPlayer
{
	
	import com.metaphile.MetaReader;
	import com.metaphile.id3.ID3Data;
	import com.metaphile.id3.ID3Reader;
	
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	
	public class FileManager
	{
		
		private var mediaPath:String;
		private var SQLConn:SQLiteConnector = Application.application.SQLConn;	
		private var settingsMgr:SettingsManager = Application.application.settingsMgr;
		private var fileStr:FileStream;
		private var loadMediaTotal:int;
		private var loadMediaCurrent:int;
		public function FileManager() {

		}
		public function get MediaPath():String { 
			return settingsMgr.MediaPath;
		}
		public function set MediaPath(setValue:String):void { 
			mediaPath = setValue; 
			settingsMgr.MediaPath = setValue;
		}
		
		public function FindMedia(url:String = ""):void {
			var directory:File = new File();
			var file:File;
			var mediaPath:String = this.MediaPath;
			
			if(mediaPath != null || mediaPath != "") {
				// Recursive Function
				if(url != "") {
					directory.nativePath = url;
				} else {
					url = mediaPath;
					directory.nativePath = mediaPath;	
				}
				var contents:Array = directory.getDirectoryListing();
				for (var i:uint = 0; i < contents.length; i++) 	{
					if(contents[i].isDirectory) {
						// Send to Recursive
						FindMedia(url+File.separator+contents[i].name);
					}
					if(contents[i].extension == "mp3") {
						try {
							loadID3(contents[i].nativePath);
							
						} catch(e:Error) {
							trace("Error FileMgr: ", e.toString());
						}
					}
				    //trace(contents[i].name, contents[i].size, contents[i].extension); 
				}
			}
			Application.application.LoadMedia(false);
			Application.application.ModuleLoader();
			
		}
		public function ReadTags():void {
			var sql:String = "SELECT * FROM Media";
			var datos:Array = SQLConn.FetchArray(sql);
			loadMediaTotal = datos.length;
			loadMediaCurrent = 0;
			for(var i:int = 0; i<datos.length; i++) {
				loadID3(datos[i]["Path"]);
			}
		}
		private function loadMedia( file:String ):void {
			var sql:String = 	'INSERT INTO Media (Path) VALUES( :param1 )';
			SQLConn.DoSQL(sql, file);
		}
		private function loadID3( path:String ):void {
			var file:File = new File(path);
			var reader:MetaReader = new MetaReader(new ID3Reader(), function (meta:ID3Data):void {
																id3Complete(meta, path)
															});
        	reader.autoClose = true;
        	reader.autoLimit = -1;
        
        	var stream:FileStream = new FileStream();
        	stream.open(file, FileMode.READ);
        	reader.read(stream);
		}
		private function id3Complete(meta:ID3Data, path:String):void {
			var id3Title:String;
			var id3Artist:String;
			var id3Album:String;
			var id3TrackNumber:String;
			var id3Year:String;
			var id3GenreCode:String
			//var frames:Array = e.target.reader.frames;
			var file:File = new File(path);
			var dir:File = new File(path.slice(0, (path.length - file.name.length)));
			
			try {
				if(meta.title != null)
					id3Title = meta.title;
				else
					id3Title = file.name;
				if(meta.performer != null)
					id3Artist = meta.performer.text;
				else
					id3Artist = dir.name;
				if(meta.subtitle != null)
					id3Album = meta.subtitle;
				else
					id3Album = "NO TAG";
				if(meta.track != null)
					id3TrackNumber = meta.track.text;
				if(meta.year != null)
					id3Year = meta.year.text;
				
			    var sql:String = 	'INSERT INTO Media (Artist, Album, Title, TrackNumber, Year, Path) VALUES (' + 
			    		' "' + id3Artist 		+ 	'" , "' + id3Album 		+ 	'" , "' + id3Title 		+	'" , '  + 
			    		id3TrackNumber	+	' , '  + id3Year +	', 	:param1)';
			    
				SQLConn.DoSQL(sql, path);
				
			} catch (error:Error) {
				trace("Read ID3 Tag Problem");
			}
		}
		public function get MediaDataProvider():ArrayCollection {
			var sql:String = "SELECT * FROM Media ORDER BY Album, Artist";
			return new ArrayCollection(SQLConn.DoSQL(sql).data);
		}
	}
}