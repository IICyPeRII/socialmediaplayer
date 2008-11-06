<?xml version="1.0" encoding="utf-8"?>
<mx:WindowedApplication xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" fontFamily="Trebuchet MS" fontSize="10" width="800" height="400" initialize="init()" viewSourceURL="srcview/index.html" backgroundGradientAlphas="[1.0, 1.0]" backgroundGradientColors="[#000000, #000000]">
	<mx:Script source="main.as" />
	<mx:ApplicationControlBar x="60" y="107" dock="true" cornerRadius="0">
		<mx:Button width="64" height="64" id="player_cover" icon="@Embed(source='images/player/cover_example.jpg')" labelPlacement="right" alpha="0.76"/>
		
		<mx:HBox width="100%" height="100%">
		<mx:VBox width="350" height="64" horizontalAlign="center" verticalAlign="middle" verticalGap="0">
			<mx:Text text="Cancion" id="player_song" fontWeight="bold" alpha="1.0"/>
			<mx:Text text="Grupo" id="player_artist"/>
			<mx:Text text="Album" id="player_album" fontWeight="normal"/>
		</mx:VBox>
		<mx:VBox width="100%" height="100%" verticalAlign="middle">
			<mx:HSlider allowTrackClick="true" id="player_trackslider" width="100%" minimum="0" maximum="1000" snapInterval="0.25" liveDragging="true"/>
			<mx:HBox width="100%" horizontalAlign="right" horizontalGap="1" verticalAlign="middle">
				<mx:Text text="00:00 / 00:00" id="player_time" fontWeight="bold"/>
				<mx:Spacer width="10"/>
				<mx:Button id="player_previous" cornerRadius="0">
					<mx:icon>@Embed(source='../bin-debug/images/player/player_start.png')</mx:icon>
				</mx:Button>
				<mx:Button id="player_play" cornerRadius="0" click="plyr.Play()" width="45">
					<mx:icon>@Embed(source='../bin-debug/images/player/player_play.png')</mx:icon>
				</mx:Button>
				<mx:Button id="player_pause" cornerRadius="0" click="plyr.Play()" visible="false" width="0">
					<mx:icon>@Embed(source='../bin-debug/images/player/player_pause.png')</mx:icon>
				</mx:Button>
				<mx:Button id="player_stop" icon="@Embed(source='../bin-debug/images/player/player_stop.png')" cornerRadius="0"/>
				<mx:Button id="player_forward" cornerRadius="0">
					<mx:icon>@Embed(source='../bin-debug/images/player/player_end.png')</mx:icon>
				</mx:Button>
			</mx:HBox>
		</mx:VBox>
		</mx:HBox>
	</mx:ApplicationControlBar>
	<mx:VBox width="100%" height="100%">
		<mx:Spacer height="5" />
		<mx:HDividedBox width="100%" height="100%">
			<mx:Accordion width="200" height="100%">
				<mx:Canvas label="Views" width="100%" height="100%">
					<mx:Tree width="100%" height="100%" dataProvider="{menuMgr.MenuViews}" labelField="@label" showRoot="false" change="MenuLoader(event)">
					</mx:Tree>
				</mx:Canvas>
				<mx:Canvas label="Queue" width="100%" height="100%">
				</mx:Canvas>
				<mx:Canvas label="Preferences" width="100%" height="100%">
					<mx:Tree width="100%" height="100%" dataProvider="{menuMgr.MenuPreferences}" labelField="@label" showRoot="false" change="MenuLoader(event)">
					</mx:Tree>
				</mx:Canvas>
			</mx:Accordion>
			<mx:ModuleLoader  width="100%" height="100%" id="ModLoader"/>
		</mx:HDividedBox>
		<mx:HBox width="100%">
			<mx:Button label="Reload Music" fontSize="8" click="{ReloadMusic()}">
				<mx:icon>@Embed(source='../bin-debug/images/player/reload.png')</mx:icon>
			</mx:Button>
			
		</mx:HBox>
	</mx:VBox>
</mx:WindowedApplication>
