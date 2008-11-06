package com.fusiox.styles {
	import flash.events.Event;
	import flash.text.StyleSheet;
	import mx.styles.StyleManager;
	import mx.styles.CSSStyleDeclaration;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject
	
	[Event(Event.COMPLETE)]
	public class CSSManager extends EventDispatcher implements IMXMLObject {
		
		private var _source:String = "";
		private static var keywords:Object = new Object();
		private static var properties:Object = new Object;
		public static var rules:Object = new Object();
		private static var styleSheetClass:StyleSheet = new StyleSheet();
		
		keywords.aqua = 0x00FFFF;
		keywords.black = 0x000000;
		keywords.blue = 0x0000FF;
		keywords.fuchsia = 0xFF00FF;
		keywords.gray = 0x808080;
		keywords.green = 0x008000;
		keywords.lime = 0x00FF00;
		keywords.maroon = 0x800000;
		keywords.navy = 0x000080;
		keywords.olive = 0x808000;
		keywords.purple = 0x800080;
		keywords.red = 0xFF0000;
		keywords.silver = 0xC0C0C0;
		keywords.teal = 0x008080;
		keywords.white = 0xFFFFFF;
		keywords.yellow = 0xFFFF00;
		
		public function set source(value:String):void {
			_source = value;
			this.load(_source);
		}
		
		public function get source():String {
			return _source;
		}
		
		public function CSSManager():void {
			
		}
		
		public function initialized(document:Object, id:String):void {
			
		}
		
		public static function createProperty(name:String,value:*,children:Array,flags:Array):Boolean {
			var values:Array;
			if(children.length == flags.length) {
				values = splitValues(String(value))
				properties[name] = new Object();
				properties[name].default = value;
				properties[name].children = children;
				properties[name].flags = flags;
				for(var ii:uint=0; ii<children.length; ii++) {
					if(properties[children[ii]]==null) {properties[children[ii]] = {value:values[ii]}};
				}
				return true;
			} else {return false};
		}
	
		public function load(url:String):void {
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(Event.COMPLETE, onLoad);
		}
	
		public static function parseCSS(text:String):void {
			styleSheetClass.parseCSS(text);
			cascadeStyles(styleSheetClass);
			styleSheetClass.clear();
		}
		
		public static function setKeyword(name:String, value:*):void {
			keywords[name] = value;
		}
		// Private functions
		private static function cascadeStyles(styleSheet:StyleSheet, importance:Number=0):void {
			var styles:Array = styleSheet.styleNames;
			for(var z:uint=0; z<styles.length; z++) {
				styles[z] = styles[z].substr(0,1).toUpperCase() + styles[z].substr(1,styles[z].length-1);
				var csd:CSSStyleDeclaration = StyleManager.getStyleDeclaration(styles[z]);
				if(csd==null) {csd = new CSSStyleDeclaration(styles[z]);}
				rules[styles[z]] = new Object();
				var style:Object = styleSheet.getStyle(styles[z]);
				for (var property:String in style) {
					var values:Array = splitValues(String(style[property]));
					// calculate children values
					if(properties[property]==null || properties[property].children==null) {
						rules[styles[z]][property] = new Object();
						rules[styles[z]][property] = parseValue(values[0]);
						csd.setStyle(property, rules[styles[z]][property].value);
						//trace(property + "-parent: " + csd.getStyle(property));
					} else {
						//rules[styles[z]][property] = new Object();
						//rules[styles[z]][property].text = style[property];
						for(var ii:uint=0; ii<properties[property].children.length; ii++) {
							if(values.length<ii+1 && properties[property].flags[ii]<0){values[ii] = values[ii + properties[property].flags[ii]]};
							rules[styles[z]][properties[property].children[ii]] = parseValue(values[ii]);
							csd.setStyle(properties[property].children[ii], rules[styles[z]][properties[property].children[ii]].value);
							//trace(properties[property].children[ii] + "-child: " + csd.getStyle(properties[property].children[ii]));
						}
					}
				}
				StyleManager.setStyleDeclaration(styles[z],csd,true);
			}
		}
		
		private static function splitValues(text:String):Array {
			var values:Array = text.split(" ");
			for(var ii:uint=0;ii<values.length;ii++) {
				if(values[ii]==""){
					values.splice(ii,1);
					ii--;
				}
			}
			return values;
		}
		
		private static function parseValue(text:String):Object {
			var temp:Object = new Object();
			temp.text = text;
			if(keywords[text]!=null) {
				temp.value = keywords[text];
				temp.type = "keyword";
			} else if(text.substr(0,1)=="'" && text.substr(text.length-1,1)=="'") {
				temp.value = text.substr(1,text.length-2);
				temp.type = "string";
			} else if(text.substr(0,1)=="#" || text.substr(0,2)=="0x") {
				temp.value = parseColor(text);
				temp.type = "color";
			} else if(text.substr(text.length-2,2)=="px") {
				temp.value = text.substr(0,text.length-2);
				temp.type = text.substr(text.length-2, 2);
			} else if (!isNaN(Number(text))) {
				temp.value = text;
				temp.type = "number";
			} else {
				temp.value = text;
				temp.type = "unknown";
			}
			return temp;
		}
		
		private static function parseColor(color:String):Number {
			if(color.substr(0,1)=="#"){color = color.substr(1,color.length-1)};
			if(color.substr(0,2)=="0x"){color = color.substr(2,color.length-2)};
			if(color.length==1){color = color + color + color + color + color + color};
			if(color.length==3){color = color.substr(0,1) + color.substr(0,1) + color.substr(1,1) + color.substr(1,1) + color.substr(2,1) + color.substr(2,1)};
			return Number("0x" + color);
		}
		
		private function onLoad(event:Event):void {
			styleSheetClass.parseCSS(event.target.data);
			cascadeStyles(styleSheetClass);
			styleSheetClass.clear();
			dispatchEvent( new Event(Event.COMPLETE,true) );
		}
	}
}