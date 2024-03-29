package com.bedrock.extras.media
{
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public interface IMedia extends IEventDispatcher
	{
		function play( $event:Event=null ):void;
		function pause( $event:Event=null ):void;
		function set paused( $value:Boolean ):void;
		function get paused():Boolean;
		function set progress( $percent:Number ):void
		function get progress():Number;
		function set forcePlay( $value:Boolean ):void;
		function get forcePlay():Boolean;
		function set volume( $value:Number ):void;
		function get volume():Number;
		function set time( $seconds:Number ):void;
		function get time():Number;
		function get duration():Number;
	}
}