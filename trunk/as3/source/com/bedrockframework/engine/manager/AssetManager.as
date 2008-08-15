﻿package com.bedrockframework.engine.manager{	/*	Imports	*/	import com.bedrockframework.core.base.StaticWidget;	import com.bedrockframework.plugin.storage.HashMap;		import flash.display.BitmapData;	import flash.display.MovieClip;	import flash.media.Sound;	/*	Class Declaration	*/	public class AssetManager extends StaticWidget	{		/*		* Variable Declarations		*/		private static var __objViewMap:HashMap;		private static var __objPreloaderMap:HashMap;		private static var __objBitmapMap:HashMap;		private static var __objSoundMap:HashMap;		/*		Initialize the class		*/		public static function initialize():void		{			__objViewMap = new HashMap;			__objPreloaderMap = new HashMap;			__objBitmapMap = new HashMap;			__objSoundMap = new HashMap;		}		/*		Add/ Return new view instance		*/		public static function addView($name:String, $class:Class):void		{			__objViewMap.saveValue($name, $class);		}		public static function getView($name:String):MovieClip		{			var clsResult:Class = __objViewMap.getValue($name);			return new clsResult;		}		public static function hasView($name:String):Boolean		{			return __objViewMap.containsKey($name);		}		/*		Add/ Return new preloader instance		*/		public static function addPreloader($name:String, $class:Class):void		{			__objPreloaderMap.saveValue($name, $class);		}		public static function getPreloader($name:String):MovieClip		{			var clsResult:Class = __objPreloaderMap.getValue($name);			return new clsResult;		}		public static function hasPreloader($name:String):Boolean		{			return __objPreloaderMap.containsKey($name);		}		/*		Add/ Return new bitmap instance		*/		public static function addBitmap($name:String, $class:Class):void		{			__objBitmapMap.saveValue($name, $class);		}		public static function getBitmap($name:String):BitmapData		{			var clsResult:Class = __objBitmapMap.getValue($name);			return new clsResult(0,0);		}		public static function hasBitmap($name:String):Boolean		{			return __objBitmapMap.containsKey($name);		}		/*		Add/ Return new sound instance		*/		public static function addSound($name:String, $class:Class):void		{			__objSoundMap.saveValue($name, $class);		}		public static function getSound($name:String):Sound		{			var clsResult:Class = __objSoundMap.getValue($name);			return new clsResult;		}		public static function hasSound($name:String):Boolean		{			return __objSoundMap.containsKey($name);		}	}}