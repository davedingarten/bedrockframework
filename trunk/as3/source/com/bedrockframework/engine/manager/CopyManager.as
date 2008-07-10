﻿package com.bedrockframework.engine.manager{	import com.bedrockframework.core.base.StaticWidget;	import com.bedrockframework.core.dispatcher.BedrockDispatcher;	import com.bedrockframework.engine.event.BedrockEvent;	import com.bedrockframework.plugin.storage.HashMap;	import com.bedrockframework.plugin.util.XMLUtil;	import com.bedrockframework.core.logging.Logger;	import com.bedrockframework.core.logging.LogLevel;		import flash.events.Event;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	public class CopyManager extends StaticWidget	{		private static var OBJ_COPY_HASH:HashMap;		private static var OBJ_URL_LOADER:URLLoader;				Logger.log(CopyManager, LogLevel.CONSTRUCTOR, "Constructed");				public static function initialize($path:String):void		{			CopyManager.OBJ_URL_LOADER = new URLLoader();			CopyManager.OBJ_URL_LOADER.addEventListener(Event.COMPLETE, CopyManager.onXMLProcess,false,0,true);			CopyManager.OBJ_URL_LOADER.addEventListener(IOErrorEvent.IO_ERROR, CopyManager.onXMLError,false,0,true);			CopyManager.OBJ_URL_LOADER.addEventListener(SecurityErrorEvent.SECURITY_ERROR, CopyManager.onXMLError,false,0,true);			CopyManager.loadXML($path);		}		public static function loadXML($path:String):void		{						CopyManager.OBJ_URL_LOADER.load(new URLRequest($path));		}				private static function parseXML($xml:String):void		{			CopyManager.OBJ_COPY_HASH = new HashMap();			var xmlCopy:XML = new XML($xml);			var objResult:Object = XMLUtil.getObject(xmlCopy);			for (var d in objResult) {				CopyManager.OBJ_COPY_HASH.saveValue(d, objResult[d]);			}			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.COPY_LOADED, CopyManager));		}				public static function getCopy($key:String):String		{			return CopyManager.OBJ_COPY_HASH.getValue($key);		}		/*		Event Handlers		*/		private static function onXMLProcess($event:Event):void		{			CopyManager.parseXML(CopyManager.OBJ_URL_LOADER.data);		}		private static function onXMLError($event:Event):void		{			Logger.warning(CopyManager, "Could not parse copy!")		}	}}