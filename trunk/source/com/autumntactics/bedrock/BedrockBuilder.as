﻿package com.autumntactics.bedrock
{

	import com.autumntactics.bedrock.base.MovieClipWidget;
	import com.autumntactics.bedrock.command.*;
	import com.autumntactics.bedrock.controller.*;
	import com.autumntactics.bedrock.dispatcher.BedrockDispatcher;
	import com.autumntactics.bedrock.events.BedrockEvent;
	import com.autumntactics.bedrock.gadget.*;
	import com.autumntactics.bedrock.manager.*;
	import com.autumntactics.bedrock.model.*;
	import com.autumntactics.bedrock.output.OutputManager;
	import com.autumntactics.bedrock.view.*;
	import com.autumntactics.display.Blocker;
	import com.autumntactics.loader.BackgroundLoader;
	import com.autumntactics.loader.VisualLoader;
	import com.autumntactics.storage.ArrayBrowser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class BedrockBuilder extends MovieClipWidget
	{
		public var configURL:String;
		private var numLoadIndex:Number;		
		private var objConfigLoader:URLLoader;
	
		private const arrLoadSequence:Array=new Array("loadDispatcher","loadParams","loadConfig","loadCacheSettings", "loadOutput","loadController","loadServices","loadTracking","loadEngineClasses","loadEngineCommands","loadEngineContainers","loadCSS", "loadCopy", "buildDefaultPanel","loadModels","loadCommands","loadViews","loadCustomization","loadComplete");
		private var objBedrockController:BedrockController;
		public var params:String
		
		public function BedrockBuilder()
		{
			this.configURL = "bedrock_config.xml";
			this.loaderInfo.addEventListener(Event.COMPLETE,this.onBootUp);
			this.numLoadIndex=0;
		}
		final public function initialize():void
		{
			this.next();
		}
		final protected function next():void
		{
			var strFunction:String=this.arrLoadSequence[this.numLoadIndex];
			this.numLoadIndex+= 1;

			var objDetails:Object = this.getProgressObject();

			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_PROGRESS,this,objDetails));

			this[strFunction]();
		}
		/*
		Determine General Location
	 	*/
	 	private function determineLocation($url:String):String
		{
			if ($url.indexOf("http") != -1) {
				return "remote";
			} else {
				return "local";
			}
		}
		/*
		Calculate Percentage
		*/
		private function getProgressObject():Object
		{
			var numPercent:int=Math.round(this.numLoadIndex / this.arrLoadSequence.length * 100);
			var objDetails:Object=new Object  ;
			objDetails.index=this.numLoadIndex;
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
			if (this.determineLocation(this.loaderInfo.url) == "remote") {
				strConfigURL = Params.getValue("configURL") ||this.configURL;
			} else {
				strConfigURL = "../../"+ this.configURL;
			}
			this.loadXML(strConfigURL);
			this.status(this.loaderInfo.url);
		}
		final private function loadCacheSettings():void
		{
			if (Config.getSetting("cache_prevention") && Config.getSetting("environment") != "local") {
				BackgroundLoader.cachePrevention = true;
				VisualLoader.cachePrevention = true;
				BackgroundLoader.cacheKey = Config.getValue("cache_key");
				VisualLoader.cacheKey = Config.getValue("cache_key");
			}
			this.next();
		}
		final private function loadOutput():void
		{
			OutputManager.outputLevel=Config.getValue("output_level");
			this.next();
		}
		final private function loadCSS():void
		{
			if (Config.getSetting("stylesheet")) {
				this.addToQueue(Config.getValue("css_path") + "style.css", null, StyleManager.onCSSLoaded);
			}
			this.next();
		}
		final private function loadCopy():void
		{
			if (Config.getSetting("copy_deck")) {
				var strPath:String;
				var arrLanguages:Array = Config.getSetting("languages");
				var objBrowser:ArrayBrowser = new ArrayBrowser(arrLanguages);
				if (arrLanguages.length > 0 && Config.getSetting("default_language") != "") {
					if (objBrowser.containsItem(Config.getSetting("language"))) {
						strPath = Config.getValue("xml_path") + Config.getSetting("language") + "_copy.xml";
					} else {
						strPath = Config.getValue("xml_path") + Config.getSetting("default_language") + "_copy.xml";
					}
				} else {
					strPath = Config.getValue("xml_path") + "copy.xml";
				}
				CopyManager.initialize(strPath);
			}			
			this.next();
		}
		final private function loadController():void
		{			
			this.objBedrockController=new BedrockController();
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
			if (Config.getSetting("auto_intro")){
				this.addCommand(BedrockEvent.BEDROCK_COMPLETE,RenderSiteCommand);
			}
			if (Config.getSetting("copy_deck")){
				this.addCommand(BedrockEvent.LOAD_COPY, LoadCopyCommand);
			}
			//
			this.next();
		}
		final private function loadEngineClasses():void
		{
			SectionStorage.save(Config.getSetting("sections"));
			State.initialize();
			if (Config.getSetting("deep_linking")) {
				URLManager.initialize()
			}
			ContainerManager.initialize(this);
			LayoutBuilder.initialize();
			LoadManager.initialize();
			PreloaderManager.initialize();
			SectionManager.initialize();
			this.next();
		}
		final private function loadEngineContainers():void
		{
			LayoutBuilder.buildLayout(Config.getSetting("layout"));
			SectionManager.set(ContainerManager.getContainer("site") as VisualLoader);
			var objBlocker:Blocker=new Blocker();
			ContainerManager.buildContainer("blocker",objBlocker);
			objBlocker.show();
			this.next();
		}
		final private function loadServices():void
		{
			try{
				ServiceManager.createServices(Config.getValue("remoting"))
			}catch($error:Error){
			}		
			this.next();
		}
		final private function loadTracking():void
		{
			TrackingManager.initialize();
			TrackingManager.enabled = Config.getValue("tracking_enabled");
			this.next();
		}
		final private function buildDefaultPanel():void
		{
			this.next();
		}
		/*
		Site Customization Functions
		*/
		public function loadModels():void
		{
			this.next();
		}
		public function loadCommands():void
		{
			this.next();
		}
		public function loadContainers():void
		{
			this.next();
		}
		public function loadViews():void
		{
			this.next();
		}
		public function loadCustomization():void
		{
			this.next();
		}
		/*
		Load Completion Notice
		*/
		final private function loadComplete():void
		{
			this.addToQueue(Config.getValue("swf_path") + "site.swf",ContainerManager.getContainer("site"));
			this.addToQueue(Config.getValue("swf_path") + "shared.swf",ContainerManager.getContainer("shared"));			
			this.status("Initialization Complete!");
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.BEDROCK_COMPLETE,this));
		}
		/*
		Add Command
		*/
		final protected function addCommand($type:String,$command:Class):void
		{
			this.objBedrockController.addCommand($type,$command);
		}
		final protected function removeCommand($type:String,$command:Class):void
		{
			this.objBedrockController.removeCommand($type,$command);
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
		final private function loadXML($path:String):void
		{
			this.createLoader();
			this.objConfigLoader.load(new URLRequest($path));
		}
		/*
		Create Loader
	 	*/
	 	final private function createLoader():void
		{
			this.objConfigLoader = new URLLoader();
			this.objConfigLoader.addEventListener(Event.COMPLETE, this.onConfigLoaded,false,0,true);
			this.objConfigLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onConfigError,false,0,true);
			this.objConfigLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError,false,0,true);
		}
	 	/*
		Clear Loader
	 	*/
	 	final private function clearLoader():void
		{			
			this.objConfigLoader.removeEventListener(Event.COMPLETE, this.onConfigLoaded);
			this.objConfigLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onConfigError);
			this.objConfigLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onConfigError);
			this.objConfigLoader = null;
		}
		/*
		
		Event Handlers
		
		*/
		final private function onConfigLoaded($event:Event):void
		{
			Config.initialize(this.objConfigLoader.data, this.loaderInfo.url, this.stage);
			BedrockDispatcher.dispatchEvent(new BedrockEvent(BedrockEvent.CONFIG_LOADED,this));
			this.next();
		}
		final private function onConfigError($event:Event):void
		{
			this.fatal("Could not parse config!");
		}
		final private function onBootUp($event:Event)
		{
			this.initialize();
		}
	}
}