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
package com.bedrock.framework.core.base
{
	import com.bedrock.framework.core.logging.ILogable;
	import com.bedrock.framework.core.logging.LogLevel;
	import com.bedrock.framework.core.logging.Logger;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipBase extends MovieClip implements ILogable
	{
		/*
		Constructor
		*/
		public function MovieClipBase()
		{
			super();
		}
		/*
		Overrides adding additional functionality
		*/
		override public  function dispatchEvent($event:Event):Boolean
		{
			return super.dispatchEvent($event);
		}
		override public  function addEventListener($type:String,$listener:Function,$capture:Boolean=false,$priority:int=0,$weak:Boolean=true):void
		{
			super.addEventListener($type,$listener,$capture,$priority,$weak);
		}
		/*
		Logging Functions
	 	*/
		private function log( $trace:*, $category:int ):String
		{
			return Logger.log( $trace, this, $category );
		}
		public function status($trace:*):String
		{
			return this.log( $trace, LogLevel.STATUS );
		}
		public function debug($trace:*):String
		{
			return this.log( $trace, LogLevel.DEBUG );
		}
		public function warning($trace:*):String
		{
			return this.log( $trace, LogLevel.WARNING );
		}
		public function error($trace:*):String
		{
			return this.log( $trace, LogLevel.ERROR );
		}
		public function fatal($trace:*):String
		{
			return this.log( $trace, LogLevel.FATAL );
		}
		
		/*
		Returns an Array of the children of the Movieclip.
		*/
		public function get children():Array
		{
			var arrChildren:Array = new Array;
			var numLength:uint = this.numChildren;
			for(var i:uint = 0; i < numLength; i++) {
				arrChildren.push( this.getChildAt( i ) );
			}
			return arrChildren;
		}
		/*        
		Removes all of the children of the Movieclip.
		*/        
		public function removeChildren():void
		{
			var numLength:int = this.children.length;
			for ( var i:int = 0; i < numLength; i ++ ) {
				this.removeChildAt(0);
			}
		}
		
	}
}