﻿package com.bedrockframework.plugin.timer{	/*	imports	*/	import flash.display.Sprite;	import com.bedrockframework.core.base.DispatcherWidget;	import com.bedrockframework.plugin.event.DelayEvent;	import flash.utils.*;	/*	class	*/	public class Delay extends DispatcherWidget	{		/*		Variables		*/		private static  var NUM_TOTAL:Number = 0;		private var _numMilliseconds:Number;		private var _numSeconds:Number;		private var _numID:uint;		private var _strName:String;		private var _bolRunning:Boolean;		/*		Constructor		*/		public function Delay($name:String = null):void		{			Delay.NUM_TOTAL +=1;			this._numID = NUM_TOTAL;			this._strName = $name;			this._bolRunning = false;		}		/*		public functions		*/		public function start($delay:Number):void		{			if (!this._bolRunning) {				this.status("Start");				this._numSeconds = $delay;				this._numMilliseconds = $delay * 1000;				this._numID = setTimeout(this.trigger, this._numMilliseconds);				this._bolRunning = true;				this.dispatchEvent(new DelayEvent(DelayEvent.START, this, {id:this._numID, seconds:this._numSeconds, milliseconds:this._numMilliseconds}));			}		}		public function stop():void		{			if (this._bolRunning) {				this.status("Stop");				this._bolRunning = false;				clearTimeout(this._numID);				this.dispatchEvent(new DelayEvent(DelayEvent.STOP, this,{id:this._numID, seconds:this._numSeconds, milliseconds:this._numMilliseconds}));			}		}		public function trigger():void		{			this._bolRunning = false;			this.dispatchEvent(new DelayEvent(DelayEvent.TRIGGER, this,{id:this._numID}));		}		/*		Property Definitions		*/		public function get id():Number		{			return this._numID;		}		public function get delay():Number		{			return this.seconds;		}		public function get seconds():Number		{			return (this._numMilliseconds / 1000);		}		public function get milliseconds():Number		{			return this._numMilliseconds / 1000;		}		public function get totalTimers():Number		{			return NUM_TOTAL;		}		public function get running():Boolean		{			return this._bolRunning;		}	}}