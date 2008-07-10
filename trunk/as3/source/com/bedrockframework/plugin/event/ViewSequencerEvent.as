package com.bedrockframework.plugin.event
{
	import com.bedrockframework.core.event.GenericEvent;

	public class ViewSequencerEvent extends GenericEvent
	{		
		public static  const NEXT:String = "ViewSequencerEvent.onNext";
		public static  const PREVIOUS:String = "ViewSequencerEvent.onPrevious";
		public static const COMPLETE:String =  "ViewSequencerEvent.onComplete";
		public static const BEGINNING:String =  "ViewSequencerEvent.onBeginning";
		public static const ENDING:String =  "ViewSequencerEvent.onEnding";
		
		public function ViewSequencerEvent($type:String, $origin:Object, $details:Object=null, $bubbles:Boolean=false, $cancelable:Boolean=true)
		{
			super($type, $origin, $details, $bubbles, $cancelable);
		}
	}
}