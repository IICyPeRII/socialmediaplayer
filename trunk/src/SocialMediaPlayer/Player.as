// GNU GPL License - 2008
//----------------------------------------------
//        Villagrán & Quiroz
//   http://www.villagranquiroz.cl
package SocialMediaPlayer
{
	import com.metaphile.MetaReader;
	import com.metaphile.id3.ID3Data;
	import com.metaphile.id3.ID3Reader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.core.Application;
	import mx.events.SliderEvent;
	
	public class Player
	{
		private var MusicFile:Sound;
		private var StateLoaded:Boolean;
		private var playing:Boolean = false;
		private var channel:SoundChannel;
		private var currentPos:int;
		private var progressInterval:int = 250;
		private var playTimer:Timer;
		private var shuffle:Boolean;
		private var reapeat:Boolean;
		private var soundTransform:SoundTransform;
		private var firstPlay:Boolean = true;
		
		public function Player()
		{
			// For Sound Volume Changing
			soundTransform = new SoundTransform();
		}
		public function LoadFile(file_url:String):void {
			Application.application.bottom_panel.VisualizationColorChange();
			MusicFile = new Sound();
			StateLoaded = false;
			MusicFile.addEventListener(Event.COMPLETE, onLoadComplete);
			MusicFile.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			try {
				loadID3(file_url);
				trace("File URL:", file_url);
				MusicFile.load(new URLRequest(file_url));
			} catch(e) {
				Next();
			}
			channel = null;
			playing = false;
			currentPos = 0;
		}
		
		// Metodos Publicos
		public function Play():void {
			if(playing){
	    		currentPos = channel.position;
	    		channel.stop();
	    		playing = false;
	    		playTimer.stop();
	    		Player_PlayButton(true);
	    	} else {
	    		
	    		if(channel != null) {
	    			channel = MusicFile.play(channel.position);
	    		}else {
	    			if(firstPlay) {
		    			Next(firstPlay);
		    			firstPlay = false;
	    			}
	    			channel = MusicFile.play();
	    		}
	    		
	    		playing = true;
	    		channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
	    		if(playTimer != null) {
	    			playTimer.removeEventListener(TimerEvent.TIMER, onPlayTimer);
	    			playTimer = null;
	    		} 
	    		playTimer = new Timer(this.progressInterval);
	           	playTimer.addEventListener(TimerEvent.TIMER, onPlayTimer);
	           	playTimer.start();
	           	Player_PlayButton(false);
	           	channel.soundTransform = soundTransform;
	           	Application.application.loadTileSimilar();
	    	}
		}
		public function PrevSong():void {
			Prev();
		}
		public function NextSong():void {
			Next();
		}
		public function volumeChange(event:SliderEvent):void {
			soundTransform.volume = event.value;
			channel.soundTransform = soundTransform;
		}
		public function positionChange(event:SliderEvent):void {
			
		}
		// Metodos Privados
		private function Player_PlayButton(toPlay:Boolean):void {
			var width1:int; var width2:int;
			var visibility1:Boolean; var visibility2:Boolean;
			if(toPlay) {
				width1 = 65; width2 = 0;
				visibility1 = true; visibility2 = false;
			} else {
				width1 = 0; width2 = 65;
				visibility1 = false; visibility2 = true;
			}
		    Application.application.player_controls.player_play.visible = visibility1;
		    Application.application.player_controls.player_play.width = width1;
		    Application.application.player_controls.player_pause.visible = visibility2;
		    Application.application.player_controls.player_pause.width = width2;
		}
		private function Next(first:Boolean = false):void {
			var mg:MediaDataGrid;
			if((mg = Application.application.ModLoader.child.MediaGrid)) {
				CloseMusicFile()
				
				var sel:int;
				var selObj:Object;
				
				var dataG:Object = Application.application.media;
				
				if(Application.application.player_controls.shuffle.selected || first) {
					sel = Math.random() * dataG.length;
					selObj = dataG.getItemAt(sel);
				} else {
					//Last item
					if(dataG.length == mg.selectedIndex+1) {
						trace("Ultimo");
						sel = 0;
						selObj = dataG.getItemAt(sel);
					} else { //Any selected item
						trace("Cualquiera"); 
						sel = mg.selectedIndex+1;
						selObj = dataG.getItemAt(sel);
					}
				}
				// selecting
				mg.selectedIndex = sel;
				// load & play
				LoadFile(selObj.Path);
				if(!first) {
					Play();
				}
				// Scroll to Song
				mg.validateNow();
				mg.scrollToIndex(sel);
			}
		}
		private function Prev():void {
			var mg:MediaDataGrid;
			if((mg = Application.application.ModLoader.child.MediaGrid)) {
				CloseMusicFile()
				
				var sel:int;
				var selObj:Object;
				
				var dataG:Object =  Application.application.media;
				
				if(Application.application.shuffle.selected) {
					sel = Math.random() * dataG.length;
					selObj = dataG.getItemAt(sel);
				} else {
					//Last item
					if(mg.selectedIndex == 0) {
						trace("Primero");
						sel = dataG.length-1;
						selObj = dataG.getItemAt(sel);
					} else { //Any selected item
						trace("Cualquiera"); 
						sel = mg.selectedIndex-1;
						selObj = dataG.getItemAt(sel);
					}
				}
				// selecting
				mg.selectedIndex = sel;
				// load & play
				LoadFile(selObj.Path);
				Play();
				// Scroll to Song
				mg.validateNow();
				mg.scrollToIndex(sel);
			}
		}
		private function onLoadComplete(event:Event):void {
		    var localSound:Sound = event.target as Sound;
		    StateLoaded = true;				
		}
		private function onIOError(event:IOErrorEvent):void {
		    trace("The sound could not be loaded: " + event.text);
		}	
		private function onPlayTimer(event:Event):void {
			var plyrTime:Text = Application.application.player_controls.player_time;
			
			var subtotal:Number=Number(MusicFile.length/MusicFile.bytesLoaded);
			var totalLenght:Number=Number(subtotal*MusicFile.bytesTotal);
			
			var seconds:Number = totalLenght/1000;
			var position:Number = channel.position/1000;
			var min:Number = Math.floor(seconds/60);
   			var sec:Number = Math.floor(seconds%60);
   			var pos:Number = Math.floor(position/60);
   			var sec2:Number = Math.floor(position%60);
   			if(sec2<=9){
           		plyrTime.text = pos+":0"+sec2+ " / " +min+":"+sec;
      		}else {
         		plyrTime.text = pos+":"+sec2+ " / " +min+":"+sec;
            }
			
		    var estimatedLength:int = 
		        Math.ceil(MusicFile.length / (MusicFile.bytesLoaded / MusicFile.bytesTotal));
		    var playbackPercent:uint = 
		        (1000 * (channel.position / estimatedLength));
		        //trace("Tamaño: "+estimatedLength);	
		    Application.application.player_controls.player_trackslider.value = playbackPercent;
		   
		}
		
		private function onPlaybackComplete(event:Event):void {
			Next();
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
			//trace(ObjectUtil.toString(meta));
			try {
				if (meta.image != null) { 
					SaveCoverArt(meta.image);
					Application.application.SongArt.source = null;
					Application.application.SongArt.source = File.documentsDirectory.resolvePath("cover.png").nativePath.toString();
					
					Application.application.CoverBoxShow.play();
					//Application.application.SongArt.width = 100;
				} else {
					Application.application.left_panel.SongArt.source = "images/player/cover_example.jpg";
					Application.application.CoverBoxHide.play();
				}
				if(meta.title != null)
					Application.application.player_controls.player_song.text = meta.title;
				if(meta.performer != null)
					Application.application.player_controls.player_artist.text = meta.performer.text;
				if(meta.subtitle != null)
					Application.application.player_controls.player_album.text = meta.subtitle;
				/*if(frames["TDRL"])
					Application.application.player_song.text += frames["TDRL"].text;*/
			} catch (error:Error) {
				trace("Read ID3 Tag Problem");
				Alert.show(error.message);
			}
		}
		public function SaveCoverArt(bytes:ByteArray):void {
			//var img:PNGEncoder = new PNGEncoder();
			//var imgByteArray:ByteArray = img.encodeByteArray(bytes, 200, 200);
			var file:File = File.documentsDirectory.resolvePath("cover.png");
			//Use a FileStream to save the bytearray as bytes to the new file
			var fs:FileStream = new FileStream();
			try{
 				//open file in write mode
 				fs.open(file,FileMode.WRITE);
 				//write bytes from the byte array
 				fs.writeBytes(bytes);
 				//close the file
 				fs.close();
			}catch(e:Error){
 				trace(e.message);
			}
		}
		public function CloseMusicFile(stop:Boolean = false):void {
			if(MusicFile != null) {
				if(channel != null)
					channel.stop();
				channel = null;
			}
		}	

	}
}
