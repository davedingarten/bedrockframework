﻿package com.bedrockframework.engine.model{	import com.bedrockframework.core.base.StaticWidget;	import com.bedrockframework.core.logging.Logger;	import com.bedrockframework.core.logging.LogLevel;	import com.bedrockframework.plugin.storage.HashMap;	import com.bedrockframework.plugin.util.*;	public class SectionStorage extends StaticWidget	{		/*		* Variable Declarations		*/		private static var __objSectionMap:HashMap=new HashMap();		private static var __objCurrent:Object;		private static var __objPrevious:Object;		/*		* Constructor		*/		Logger.log(SectionStorage, LogLevel.CONSTRUCTOR, "Constructed");		/*		Save the page information for later use.		*/		public static function save($sections:Array):void		{			var numLength:Number=$sections.length;			for (var i:Number=0; i < numLength; i++) {				var objSection:Object=$sections[i];				SectionStorage.__objSectionMap.saveValue(objSection.alias,objSection);			}		}		/*		Pull the information for a specific page.		*/		public static function getSection($identifier:String):Object		{			var objSection:Object=SectionStorage.__objSectionMap.getValue($identifier);			if (objSection == null) {				Logger.warning(SectionStorage, "Section \'" + $identifier + "\' does not exist!");			}			return objSection;		}		/*		Set Queue		*/		public static function setQueue($identifier:String):void		{			var objSection:Object=SectionStorage.getSection($identifier);			if (objSection) {				if (objSection != SectionStorage.__objCurrent) {					SectionStorage.__objPrevious=SectionStorage.__objCurrent;					SectionStorage.__objCurrent=objSection;				} else {					Logger.status(SectionStorage, "Section already in queue!","warning");				}			} else {				Logger.status(SectionStorage, "Section is not storage!","warning");			}		}		/*		Get Section Names		*/		public static function getSectionProperties($property:String):Array {			var arrResult:Array = new Array()			var arrKeys:Array = SectionStorage.__objSectionMap.getKeys()			var numLength:Number =  arrKeys.length			for (var i:Number=0; i < numLength; i ++) { 				arrResult.push(SectionStorage.__objSectionMap.getValue(arrKeys[i])[$property])			}			return arrResult;		}		/*		Load Queue		*/		public static function loadQueue():Object		{			var objTemp:Object=SectionStorage.current;			if (objTemp == null) {				Logger.warning(SectionStorage, "Queue is empty!");			}			return objTemp;		}		/*		Clear Queue		*/		public static function clearQueue():void		{			SectionStorage.__objCurrent=null;			SectionStorage.__objPrevious=null;		}		/*		Get Current Queue		*/		public static function get current():Object		{			return SectionStorage.__objCurrent;		}		/*		Get Previous Queue		*/		public static function get previous():Object		{			return SectionStorage.__objPrevious;		}				public static function get sections():Array		{			return SectionStorage.__objSectionMap.getValues().sortOn("order", Array.NUMERIC);		}	}}