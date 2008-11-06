// GNU GPL License - 2008
//----------------------------------------------
//        Villagrán & Quiroz
//   http://www.villagranquiroz.cl

import SocialMediaPlayer.FileManager;
import SocialMediaPlayer.MenuManager;
import SocialMediaPlayer.Player;
import SocialMediaPlayer.SQLiteConnector;
import SocialMediaPlayer.updateManager;

import flash.desktop.NativeApplication;
import flash.desktop.SystemTrayIcon;
import flash.events.Event;

import modules.PopupWindow;

import mx.collections.ArrayCollection;
import mx.controls.FlexNativeMenu;
import mx.controls.Tree;
import mx.core.BitmapAsset;
import mx.events.FlexNativeMenuEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;

public var SQLConn:SQLiteConnector;
public var plyr:Player;
public var fileMgr:FileManager;
public var popUp:PopupWindow;
[Bindable] public var media:ArrayCollection;
[Bindable] private var myMenu:FlexNativeMenu;
private const defaultModule:String = "modules/views/DefaultView/DefaultView.swf";

[Bindable]
private var menuMgr:MenuManager;

[Embed(source="images/player/gtk-media-play-ltr.png")]
[Bindable] private var dockIcon:Class;
public var trayIcon:SystemTrayIcon;

private var search_string:String = "";

// UPDATE
import mx.controls.Alert;

private var um:updateManager; 

private function init():void {
	//SkinSwitcher("skins/darkroom/style/darkroom.swf");
	// Tray
	var img:BitmapAsset = new dockIcon() as BitmapAsset;
	myMenu = new FlexNativeMenu();
    myMenu.dataProvider = menuData;
    myMenu.labelField = "@label";
    myMenu.showRoot = false;
    myMenu.addEventListener(FlexNativeMenuEvent.ITEM_CLICK, trayMenuClick);
    
	NativeApplication.nativeApplication.icon.bitmaps = [img.bitmapData];
	// Player	
	plyr = new Player();
	menuMgr = new MenuManager();
	SQLConn = new SQLiteConnector();
	SQLConn.DbFile = "FlexMP.sqlite"
	fileMgr = new FileManager();
	// Setting Default Media Path
	fileMgr.MediaPath = SQLConn.FetchOne("SELECT MediaPath FROM Preferences;");
	ModuleLoader();
	LoadMedia(true);
	um = new updateManager();
	um.UpdateButton = updateButton;
	um.checkForUpdate();
	

}
public function LoadMedia(firstLoad:Boolean = true):void {
	media = fileMgr.MediaDataProvider;
	if(!firstLoad)
		MediaTree();
}


private function MediaTree():void {
	var strXML:String = "<media>\r" + 
			"\t<node label=\"View All\" data=\"0\" />\r";
	
	for each(var o:Object in SQLConn.FetchArray("SELECT DISTINCT Artist as label FROM Media")) {
		if(o != null)
			strXML += "<node label=\""+o.label+"\" data=\"artist\">\r";
		
		for each(var a:Object in SQLConn.FetchArray("SELECT DISTINCT Album as label FROM Media WHERE Artist = :param1", o.label)) {
			if(a != null)
				strXML += "\t<node label=\""+a.label+"\" data=\"album\" />\r";
		}
		if(o != null)
			strXML += "</node>\r";

	}
	strXML += "</media>";
	//trace(strXML);
	left_panel.media_tree.dataProvider = new XML(strXML);
	
	media.filterFunction = filterMediaTree;
	trayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
	trayIcon.tooltip = "Social Media Player\rhttp://www.villagranquiroz.cl";
	
	similar_artist.setStyle("dataChangeEffect", myTileListEffect);
}
private function filterMediaTree(item:Object):Boolean {
	var show:Boolean = true;
	
	if(left_panel.media_tree.selectedItem.@data == "artist") {
		if(!(left_panel.media_tree.selectedItem.@label == item.Artist))
			show = false;
	}
	if(left_panel.media_tree.selectedItem.@data == "album") {
		if(!(left_panel.media_tree.selectedItem.@label == item.Album))
			show = false;
	}
	if(search_string.length > 0) {
		if(item.Title.search(search_string) != -1) {
			return true;
		}
	}
	return show;
}
public function Search(search:String = ""):void {
	search_string = search;
	media.refresh();
}

private function trayMenuClick(event:FlexNativeMenuEvent):void {
	switch(event.label) {
		case "Prev Song":
			plyr.PrevSong();
			break;
		case "Next Song":
			plyr.NextSong();
			break;
		case "Play/Pause":
			plyr.Play();
		case "Website":
			break;
		case "Exit":
			exit();
			break;
	}
}
private function MenuClick(event:MenuEvent):void {
	
	switch(event.item.@data.toString()) {
		case "quit":
			exit();
		break;
		default:
			var popWin:PopupWindow = PopupWindow(PopUpManager.createPopUp(this, PopupWindow, true));
			popWin.title = event.item.@label.toString();
			popWin.popupModLoader.url = event.item.@data.toString();
			PopUpManager.centerPopUp(popWin);
		break;
	}
}
private function MenuLoader(event:Event):void {
	
	var arbol:Tree = Tree(event.target); 
	var selectedNode:XML;
	selectedNode=arbol.selectedItem as XML;
	ModLoader.url = selectedNode.@data.toString();
}
public function ModuleLoader(Module:String = this.defaultModule):void {
	ModLoader.url = null;
	ModLoader.url = Module;
}
public function ReloadMusic():void {
	if(fileMgr.MediaPath != null) { 
		info.text = "Loading files...";
		var sql:String;
		sql = "DELETE FROM Media WHERE 1";
		SQLConn.DoSQL(sql);
		fileMgr.FindMedia();
		//fileMgr.ReadTags();
		info.text = "Files loaded";
	}
}

