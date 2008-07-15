﻿package com.bedrockframework.core.dispatcher{	import com.bedrockframework.core.base.StaticWidget;	import com.bedrockframework.core.event.GenericEvent;	import com.bedrockframework.core.logging.LogLevel;	import com.bedrockframework.core.logging.Logger;		import flash.events.EventDispatcher;	public class BedrockDispatcher extends StaticWidget	{		/*		* Variable Declarations		*/		private static var __objEventDispatcher:EventDispatcher = new EventDispatcher();		/*		* Constructor		*/		Logger.log(BedrockDispatcher, LogLevel.CONSTRUCTOR, "Constructed");		/*		Dispatch Event		*/		public static function dispatchEvent($event:GenericEvent):Boolean		{						return BedrockDispatcher.__objEventDispatcher.dispatchEvent($event);		}		/*		Write something descriptive.		*/		public static function addEventListener($type:String, $listener:Function, $capture:Boolean = false, $priority:int = 0, $weak:Boolean = true):void		{			BedrockDispatcher.__objEventDispatcher.addEventListener($type, $listener, $capture, $priority, $weak);		}		public static function removeEventListener($type:String, $listener:Function, $capture:Boolean = false):void		{			BedrockDispatcher.__objEventDispatcher.removeEventListener($type, $listener, $capture);		}		public static function hasEventListener($type:String):void		{			BedrockDispatcher.__objEventDispatcher.hasEventListener($type);		}		public static function willTrigger($type:String):void		{			BedrockDispatcher.__objEventDispatcher.willTrigger($type);		}	}}