﻿package com.builtonbedrock.bedrock.events
{
	import flash.events.Event;
	import flash.utils.*;

	public class GenericEvent extends Event
	{
		public var origin:Object;
		public var details:Object;
		/*
		Constructor
		*/
		public function GenericEvent($type:String, $origin:Object, $details:Object = null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type,$bubbles,$cancelable);
			this.origin=$origin;
			this.details=$details;
		}

		override public function clone():Event
		{
			var strName:String=getQualifiedClassName(this);
			var clsClone:Class = getDefinitionByName(strName) as Class;
			return new clsClone(this.type,this.origin,this.details);
		}
		
	}

}