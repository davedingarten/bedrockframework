﻿/**
 * Bedrock Framework for Adobe Flash ©2007-2008
 * 
 * Written by: Alex Toledo
 * email: alex@builtonbedrock.com
 * website: http://www.builtonbedrock.com/
 * blog: http://blog.builtonbedrock.com/
 * 
 * By using the Bedrock Framework, you agree to keep the above contact information in the source code.
 *
*/
package com.bedrockframework.engine
{
	
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.core.dispatcher.BedrockDispatcher;
	import com.bedrockframework.core.logging.LogLevel;
	import com.bedrockframework.core.logging.Logger;
	import com.bedrockframework.engine.command.*;
	import com.bedrockframework.engine.controller.*;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.manager.*;
	import com.bedrockframework.engine.model.*;
	import com.bedrockframework.engine.view.*;
	import com.bedrockframework.plugin.display.Blocker;
	import com.bedrockframework.plugin.event.LoaderEvent;
	import com.bedrockframework.plugin.gadget.*;
	import com.bedrockframework.plugin.loader.BackgroundLoader;
	import com.bedrockframework.plugin.loader.VisualLoader;
	import com.bedrockframework.plugin.storage.ArrayBrowser;
	import com.bedrockframework.plugin.tracking.ITrackingService;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BedrockBuilder extends MovieClipWidget
	{
		/*
		Variable Declarations
		*/
		public var configURL:String;
		public var params:String
		
		private var _numLoadIndex:Number;		
		private var _objConfigLoader:URLLoader;
		private const _arrLoadSequence:Array=new Array("loadDispatcher","loadParams","loadConfig","loadDeepLinking","loadCacheSettings", "loadLogging","loadController","loadServices","loadTracking","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "loadDefaultSection", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadTracking","loadCustomization","loadComplete");
		private var _objBedrockController:BedrockController;
		/*
		Constructor
		*/
		public function BedrockBuilder()
		{
			this.configURL = "../../" + BedrockData.CONFIG_FILENAME + ".xml";
			this.loaderInfo.addEventListener(Event.COMPLETE,this.onBootUp);
			this._numLoadIndex=0;
		}
		/**
		 * The initialize function is automatically called once the shell.swf has finished loading itself.
		 */
		final protected function initialize():void
		{
			this.next();
		}
		final protected function next():void
		{
			var strFunction:String=this._arrLoadSequence[this._numLoadIndex];
			this._numLoadIndex+= 1;

			var objDetails:Object = this.getProgressObject();

			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_PROGRESS,this,objDetails));

			this[strFunction]();
		}
		/*
		Calculate Percentage
		*/
		private function getProgressObject():Object
		{
			var numPercent:int=Math.round(this._numLoadIndex / this._arrLoadSequence.length * 100);
			var objDetails:Object=new Object  ;
			objDetails.index=this._numLoadIndex;
			objDetails.percent=numPercent;
			return objDetails;
		}
		
		/*
		Sequential Functions
		*/
		final private function loadDispatcher():void
		{
			this.next();
		}

		final private function loadParams():void
		{
			Params.parse(this.params);
			Params.save(this.loaderInfo.parameters);
			this.next();
		}
		
		final private function loadConfig():void
		{
			var strConfigURL:String;
			this.loadConfigXML(Params.getValue(BedrockData.CONFIG_URL) ||this.configURL);
			this.status(this.loaderInfo.url);
		}
		final private function loadDeepLinking():void
		{
			if (Config.getSetting(BedrockData.DEEP_LINKING_ENABLED)) {
				DeepLinkManager.initialize();
				BedrockDispatcher.addEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			} else {
				this.next();
			}	
		}
		final private function loadCacheSettings():void
		{
			if (Config.getSetting(BedrockData.CACHE_PREVENTION_ENABLED) && Config.getSetting(BedrockData.ENVIRONMENT) != BedrockData.LOCAL) {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = Config.getValue(BedrockData.CACHE_KEY);
				VisualLoader.cacheKey = Config.getValue(BedrockData.CACHE_KEY);
			}
			this.next();
		}
		final private function loadLogging():void
		{
			Logger.localLevel = LogLevel[Params.getValue(BedrockData.LOCAL_LOG_LEVEL)  || Config.getValue(BedrockData.LOCAL_LOG_LEVEL)];
			Logger.eventLevel = LogLevel[Params.getValue(BedrockData.EVENT_LOG_LEVEL)  || Config.getValue(BedrockData.EVENT_LOG_LEVEL)];
			Logger.remoteLevel = LogLevel[Params.getValue(BedrockData.REMOTE_LOG_LEVEL)  || Config.getValue(BedrockData.REMOTE_LOG_LEVEL)];
			Logger.remoteLogURL = Config.getValue(BedrockData.REMOTE_LOG_URL);
			this.next();
		}
		final private function loadCSS():void
		{
			if (Config.getSetting(BedrockData.STYLESHEET_ENABLED)) {
				this.addToQueue(Config.getValue(BedrockData.CSS_PATH) + BedrockData.STYLESHEET_FILENAME + ".css", null, this.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (Config.getSetting(BedrockData.COPY_DECK_ENABLED)) {
				var strPath:String;
				var arrLanguages:Array = Config.getSetting(BedrockData.LANGUAGES);
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				if (arrLanguages.length > 0 && Config.getSetting(BedrockData.DEFAULT_LANGUAGE) != "") {
					if (objBrowser.containsItem(Config.getSetting(BedrockData.CURRENT_LANGUAGE))) {
						strPath = Config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + Config.getSetting(BedrockData.CURRENT_LANGUAGE) + ".xml";
					} else {
						strPath = Config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + "_" + Config.getSetting(BedrockData.DEFAULT_LANGUAGE) + ".xml";
					}
				} else {
					strPath = Config.getValue(BedrockData.XML_PATH) + BedrockData.COPY_DECK_FILENAME + ".xml";
				}
				CopyManager.initialize(strPath);
			}			
			this.next();
		}
		final private function loadController():void
		{			
			this._objBedrockController=new BedrockController();
			this.next();
		}
		final private function loadEngineCommands():void
		{			
			this.addCommand(BedrockEvent.SET_QUEUE,SetQueueCommand);
			this.addCommand(BedrockEvent.LOAD_QUEUE,LoadQueueCommand);
			this.addCommand(BedrockEvent.DO_DEFAULT,DoDefaultCommand);
			this.addCommand(BedrockEvent.DO_CHANGE,DoChangeCommand);
			this.addCommand(BedrockEvent.RENDER_VIEW,RenderViewCommand);
			this.addCommand(BedrockEvent.RENDER_PRELOADER,RenderPreloaderCommand);
			
			this.addCommand(BedrockEvent.RENDER_SITE,RenderSiteCommand);
			this.addCommand(BedrockEvent.URL_CHANGE, URLChangeCommand);
			//
			this.addCommand(BedrockEvent.SHOW_BLOCKER,ShowBlockerCommand);
			this.addCommand(BedrockEvent.HIDE_BLOCKER,HideBlockerCommand);
			this.addCommand(BedrockEvent.SET_QUEUE,ShowBlockerCommand);
			this.addCommand(BedrockEvent.INTRO_COMPLETE,HideBlockerCommand);
			//
			this.addCommand(BedrockEvent.SET_QUEUE, StateChangeCommand);
			this.addCommand(BedrockEvent.INITIALIZE_COMPLETE, StateChangeCommand);
			//
			if (Config.getSetting(BedrockData.AUTO_INTRO_ENABLED)){
				this.addCommand(BedrockEvent.BEDROCK_COMPLETE,RenderSiteCommand);
			}
			if (Config.getSetting(BedrockData.COPY_DECK_ENABLED)){
				this.addCommand(BedrockEvent.LOAD_COPY, LoadCopyCommand);
			}
			//
			this.next();
		}
		final private function loadEngineClasses():void
		{
			State.initialize();
			ContainerManager.initialize(this);
			LoadManager.initialize();
			PreloaderManager.initialize();
			TransitionManager.initialize();
			
			TrackingManager.initialize(Config.getValue(BedrockData.TRACKING_ENABLED));
			
			this.next();			
		}
		final private function loadEngineContainers():void
		{
			LayoutManager.buildLayout(Config.getSetting(BedrockData.LAYOUT));
			TransitionManager.siteLoader = ContainerManager.getContainer(BedrockData.SITE_CONTAINER) as VisualLoader;
			TransitionManager.sectionLoader = ContainerManager.getContainer(BedrockData.SECTION_CONTAINER) as VisualLoader;
			
			ContainerManager.buildContainer(BedrockData.PRELOADER_CONTAINER, new Sprite);
				
			var objBlocker:Blocker=new Blocker(Params.getValue(BedrockData.BLOCKER_ALPHA));
			ContainerManager.buildContainer(BedrockData.BLOCKER_CONTAINER, objBlocker);
			objBlocker.show();
			
			this.next();
		}
		final private function loadServices():void
		{
			try{
				if (Config.getSetting(BedrockData.REMOTING_ENABLED)) {
					ServiceManager.createServices(Config.getValue(BedrockData.REMOTING))
				}				
			}catch($error:Error){
			}
			this.next();
		}
		final private function buildDefaultPanel():void
		{
			this.next();
		}
		final private function loadDefaultSection():void
		{
			if (Config.getSetting(BedrockData.AUTO_DEFAULT_ENABLED)) {
				SectionManager.setupSectionLoad(Config.getSection(SectionManager.getDefaultSection()));
			}
			this.next();
		}
		/*
		Site Customization Functions
		*/
		
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			this.addToQueue(Config.getValue(BedrockData.SWF_PATH) + BedrockData.SITE_FILENAME + ".swf", ContainerManager.getContainer(BedrockData.SITE_CONTAINER));
			this.addToQueue(Config.getValue(BedrockData.SWF_PATH) + BedrockData.SHARED_FILENAME + ".swf", ContainerManager.getContainer(BedrockData.SHARED_CONTAINER));			
			this.status("Initialization Complete!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_COMPLETE,this));
		}
		/*
		Add Command
		*/
		/**
		 * Adds an event/command relationship to the BedrockController.
		 */
		final protected function addCommand($type:String,$command:Class):void
		{
			this._objBedrockController.addCommand($type,$command);
		}
		/**
		 * Removes an event/command relationship to the BedrockController.
		 */
		final protected function removeCommand($type:String,$command:Class):void
		{
			this._objBedrockController.removeCommand($type,$command);
		}
		/*
		Add Tracking Service
		*/
		final protected function addTrackingService($name:String, $service:ITrackingService):void
		{
			TrackingManager.addService($name, $service);
		}
		/*
		Add View Functions
		*/
		final protected function addToQueue($path:String,$loader:*,$completeHandler:Function=null, $errorHandler:Function=null):void
		{
			LoadManager.addToQueue($path, $loader, $completeHandler, $errorHandler);
		}
		/*
		Config Related Stuff
		*/
		final private function loadConfigXML($path:String):void
		{
			this.createLoader();
			this._objConfigLoader.load(new URLRequest($path));
		}
		/*
		Create Loader
	 	*/
	 	final private function createLoader():void
		{
			this._objConfigLoader = new URLLoader();
			this._objConfigLoader.addEventListener(Event.COMPLETE, this.onConfigLoaded,false,0,true);
			this._objConfigLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onConfigError,false,0,true);
			this._objConfigLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError,false,0,true);
		}
	 	/*
		Clear Loader
	 	*/
	 	final private function clearLoader():void
		{			
			this._objConfigLoader.removeEventListener(Event.COMPLETE, this.onConfigLoaded);
			this._objConfigLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onConfigError);
			this._objConfigLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError);
			this._objConfigLoader = null;
		}
		/*
		Event Handlers
		*/
		final private function onBootUp($event:Event):void
		{
			this.initialize();
		}
		final private function onConfigLoaded($event:Event):void
		{
			Config.initialize(this._objConfigLoader.data, this.loaderInfo.url, this.stage);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onDeepLinkInitialized($event:BedrockEvent):void
		{
			Params.save($event.details.query);
			BedrockDispatcher.removeEventListener(BedrockEvent.DEEP_LINK_INITIALIZE, this.onDeepLinkInitialized);
			this.next();
		}
		
		final private function onConfigError($event:Event):void
		{
			this.fatal("Could not parse config!");
		}
		final private function onCSSLoaded($event:LoaderEvent):void
		{
			StyleManager.parseCSS($event.details.data);
		}
	}
}