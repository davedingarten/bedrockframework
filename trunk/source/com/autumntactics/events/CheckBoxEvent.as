﻿package com.autumntactics.events
{
	import flash.events.MouseEvent;
	import com.autumntactics.bedrock.events.GenericEvent;

	public class CheckBoxEvent extends GenericEvent
	{
		public static const CHECK:String = "CheckBoxEvent.onCheck";
		public static const UNCHECK:String = "CheckBoxEvent.onUncheck";

		public function CheckBoxEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}