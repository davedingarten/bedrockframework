﻿package com.bedrockframework.engine.manager
{
	import com.bedrockframework.core.base.StaticWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.event.ViewEvent;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.model.Queue;
	import com.bedrockframework.engine.view.IView;
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	import flash.utils.*;

	public class TransitionManager extends StaticWidget
	{
		public static var siteLoader:VisualLoader;
		public static var site:IView;
		
		public static var sectionLoader:VisualLoader;
		public static var section:IView;

		Logger.log(TransitionManager, LogLevel.CONSTRUCTOR, "Constructed");
		
		public static function reset():void
		{
			TransitionManager.sectionLoader=null;
			TransitionManager.section=null;
		}
		public static function initialize():void
		{
			BedrockDispatcher.addEventListener(BedrockEvent.DO_INITIALIZE,TransitionManager.onDoInitialize);
			BedrockDispatcher.addEventListener(BedrockEvent.LOAD_COMPLETE,TransitionManager.onLoadComplete);
		}
		/*
		Manager Event Listening
		*/
		private static function addSectionListeners($target:*):void
		{
			$target.addEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onSectionInitializeComplete);
			$target.addEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onSectionIntroComplete);
			$target.addEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onSectionOutroComplete);
		}
		private static function removeSectionListeners($target:*):void
		{
			$target.removeEventListener(ViewEvent.INITIALIZE_COMPLETE,TransitionManager.onSectionInitializeComplete);
			$target.removeEventListener(ViewEvent.INTRO_COMPLETE,TransitionManager.onSectionIntroComplete);
			$target.removeEventListener(ViewEvent.OUTRO_COMPLETE,TransitionManager.onSectionOutroComplete);
		}
		public static function outro():void
		{
			TransitionManager.section.outro();
		}
		/*
		Create a detail object to be sent out with events
	 	*/
	 	private static function getDetailObject():Object
		{
			var objDetail:Object = new Object();
			try {
				objDetail.section = Queue.current;
			} catch ($e:Error) {
			}
			objDetail.view = TransitionManager.section;
			return objDetail;
		}
		/*
		Framework Event Handlers
		*/
		private static function onDoInitialize($event:BedrockEvent):void
		{
			TransitionManager.section.initialize();
		}
		private static function onLoadComplete($event:BedrockEvent):void
		{
			TransitionManager.section=TransitionManager.sectionLoader.content as IView;
			TransitionManager.addSectionListeners(TransitionManager.section);
		}
		/*
		Individual Section View Handlers
		*/
		private static function onSectionInitializeComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INITIALIZE_COMPLETE, TransitionManager.section, TransitionManager.getDetailObject()));
			TransitionManager.section.intro();
		}
		private static function onSectionIntroComplete($event:ViewEvent):void
		{
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.INTRO_COMPLETE, TransitionManager.section, TransitionManager.getDetailObject()));
		}
		private static function onSectionOutroComplete($event:ViewEvent):void
		{
			TransitionManager.removeSectionListeners(TransitionManager.section);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.OUTRO_COMPLETE, TransitionManager.section, TransitionManager.getDetailObject()));			
			TransitionManager.section.clear();
			TransitionManager.sectionLoader.unload();
			TransitionManager.reset();
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.RENDER_PRELOADER,TransitionManager.sectionLoader));
		}
		/*
		Set the current container to load content into
	 	*/

	 	public static function set container($loader:VisualLoader):void
		{
			TransitionManager.sectionLoader=$loader;
		}
		public static function get container():VisualLoader
		{
			return TransitionManager.sectionLoader;
		}
	}

}