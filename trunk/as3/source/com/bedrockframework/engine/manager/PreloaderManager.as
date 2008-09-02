﻿package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.plugin.event.ViewEvent;
	import com.bedrockframework.engine.view.IPreloader;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.core.logging.LogLevel;
	
	public class PreloaderManager extends StaticWidget
	{
		/*
		* Variable Declarations
		*/
		private static var __objPreloader:IPreloader;
		/*
		* Constructor
		*/
		Logger.log(PreloaderManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_BEGIN,PreloaderManager.onLoadBegin);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_PROGRESS,PreloaderManager.onLoadProgress);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,PreloaderManager.onLoadComplete);
		}
		/*
		Manager Event Listening
		*/
		private static function addListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,PreloaderManager.onInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,PreloaderManager.onIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,PreloaderManager.onOutroComplete);
		}
		private static function removeListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,PreloaderManager.onInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,PreloaderManager.onIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,PreloaderManager.onOutroComplete);
		}
		/*
		Framework Event Handlers
		*/
		private static function onLoadBegin($event:BedrockEvent):void
		{
			PreloaderManager.__objPreloader.displayProgress(0);
		}
		private static function onLoadProgress($event:BedrockEvent):void
		{
			PreloaderManager.__objPreloader.displayProgress($event.details.overallPercent);
		}
		private static function onLoadComplete($event:BedrockEvent):void
		{
			PreloaderManager.__objPreloader.displayProgress(100);
			PreloaderManager.__objPreloader.outro();
		}
		/*
		Individual Preloader Handlers
		*/
		private static function onInitializeComplete($event:ViewEvent):void
		{
			PreloaderManager.__objPreloader.intro();
		}
		private static function onIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.LOAD_QUEUE, PreloaderManager));
		}
		private static function onOutroComplete($event:ViewEvent):void
		{
			PreloaderManager.removeListeners(PreloaderManager.__objPreloader);
			PreloaderManager.__objPreloader.clear();
			PreloaderManager.__objPreloader.remove();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.DO_INITIALIZE, PreloaderManager));
		}
		/*
		Set the display for the preloader
	 	*/
	 	public static function set container($preloader:IPreloader):void
		{
			PreloaderManager.__objPreloader=$preloader;
			PreloaderManager.addListeners(PreloaderManager.__objPreloader);
			PreloaderManager.__objPreloader.initialize();
		}
		public static function get container():IPreloader
		{
			return PreloaderManager.__objPreloader;
		}
	}

}