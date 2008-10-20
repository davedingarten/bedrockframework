﻿package com.bedrockframework.engine.manager{	import com.bedrockframework.core.base.StandardWidget;	import com.bedrockframework.core.logging.LogLevel;	import com.bedrockframework.core.logging.Logger;	import com.bedrockframework.engine.api.ITrackingManager;	import com.bedrockframework.plugin.event.TimeoutTriggerEvent;	import com.bedrockframework.plugin.storage.HashMap;	import com.bedrockframework.plugin.timer.TimeoutTrigger;	import com.bedrockframework.plugin.tracking.ITrackingService;	public class TrackingManager extends StandardWidget implements ITrackingManager	{		/*		* Variable Declarations		*/		private var _bolTracking:Boolean = true;		private var _objTrackDelay:TimeoutTrigger;		private var _objServiceMap:HashMap;		private var _arrQueue:Array;		/*		* Constructor		*/		public function TrackingManager()
		{

		}		/*		Initialize		*/		public function initialize($enabled:Boolean = true):void		{			this.enabled = $enabled;			this._objServiceMap = new HashMap();			this._arrQueue = new Array;			this._objTrackDelay = new TimeoutTrigger;			this._objTrackDelay.addEventListener(TimeoutTriggerEvent.TRIGGER, this.onTrack);			this._objTrackDelay.silenceLogging = true;		}		/*		Run Tracking		*/		public function track($name:String, $details:Object):void		{			if (this.enabled) {				var objService:Object = this.getService($name);				if (objService) {					this.addToQueue($name, $details);				}				this.startDelay();			}		}		private function execute($name:String, $details:Object):void		{			var objService:Object = this.getService($name);			if (objService) {				objService.track($details);			}		}		private function startDelay():void		{			if (this._arrQueue.length > 0) {				if (!this._objTrackDelay.running) {					this._objTrackDelay.start(0.5);				}			}		}		/*		Add/ Get Services		*/		public function addService($name:String, $service:ITrackingService):void		{			this._objServiceMap.saveValue($name, $service);		}		public function getService($name:String):Object		{			return this._objServiceMap.getValue($name);		}		/*		Queue Functions 		*/		private function addToQueue($name:String, $details:Object):void		{			this._arrQueue.push({name:$name, details:$details});		}		private function getNextQueueItem():Object		{			return this._arrQueue.shift();		}		/*		Event Handlers		*/		private function onTrack($event:TimeoutTriggerEvent):void		{			var objDetails:Object = this.getNextQueueItem();			if (objDetails != null) {				this.execute(objDetails.name, objDetails.details);			}			this.startDelay()		}		/*		Property Definitions		*/		public function set enabled($status:Boolean):void		{			Logger.status(TrackingManager, "Track status set to - " + $status)			this._bolTracking = $status;		}		public function get enabled():Boolean		{			return this._bolTracking;		}	}}