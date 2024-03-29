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
package com.bedrock.framework.core.dispatcher
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class DispatcherBase extends EventDispatcher implements IEventDispatcher
	{
		/*
		Constructor
		*/
		public function DispatcherBase()
		{
		}
		/*
		Overrides adding additional functionality
		*/
		override public function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
	}
}