package com.autumntactics.events
{
	import com.autumntactics.bedrock.events.GenericEvent;

	public class PaginationEvent extends GenericEvent
	{
		public static const UPDATE:String = "PaginationEvent.onUpdate";
		public static const RESET:String = "PaginationEvent.onReset";
		public static const SELECT_PAGE:String = "PaginationEvent.onSelectPage";
	
		public function PaginationEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
		
	}
}