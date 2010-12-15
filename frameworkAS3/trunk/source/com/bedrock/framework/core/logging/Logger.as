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
package com.bedrock.framework.core.logging
{
	import com.bedrock.framework.core.base.StaticBase;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Logger extends StaticBase
	{
		/*
		Variable Declarations
		*/
		public static var traceLevel:int = LogLevel.ALL;
		public static var eventLevel:int = LogLevel.ERROR;
		public static var remoteLevel:int = LogLevel.FATAL;
		public static var monsterLevel:int = LogLevel.NONE;
		
		public static var traceLogger:ILogger;
		public static var eventLogger:ILogger;
		public static var remoteLogger:IRemoteLogger;
		
		public static var errorsEnabled:Boolean = true;
		public static var detailDepth:uint = 10;
		
		private static var __initialized:Boolean = false;
		
		public static function initialize():void
		{
			Logger.__initialized = true;
			Logger.traceLogger = new TraceLogger( Logger.detailDepth );
			Logger.eventLogger = new EventLogger;
			Logger.remoteLogger = new RemoteLogger;
		}
		
		public static function log( $trace:*=null, $category:int = 0 ):String
		{
			if ( !Logger.__initialized ) Logger.initialize();
			
			var data:LogData = new LogData( new Error, $category );
			
			if ($category >= Logger.remoteLevel) {
				Logger.remoteLogger.log( $trace, data );
			}
			if ($category >= Logger.eventLevel) {
				Logger.eventLogger.log( $trace, data );
			}
			if ($category >= Logger.monsterLevel ) {
				MonsterDebugger.inspect( $trace );
			}
			
			if ($category >= Logger.traceLevel) {
				return Logger.traceLogger.log( $trace, data );
			}
			return null;
		}
		public static function status( $trace:*=null ):String
		{
			return Logger.log( $trace, LogLevel.STATUS );
		}
		public static function debug( $trace:*=null ):String
		{
			return Logger.log( $trace, LogLevel.DEBUG );
		}
		public static function warning( $trace:*=null ):String
		{
			return Logger.log( $trace, LogLevel.WARNING );
		}
		public static function error( $trace:*=null ):String
		{
			if ( Logger.errorsEnabled ) {
				Logger.log( $trace, LogLevel.ERROR );
				throw new Error( $trace.toString() );
			} else {
				return Logger.log( $trace, LogLevel.ERROR );
			}
		}
		public static function fatal( $trace:*=null ):String
		{
			return Logger.log( $trace, LogLevel.FATAL );
		}
		
		
		
		public static function set remoteLogURL($url:String):void
		{
			Logger.remoteLogger.loggerURL = $url;
		}
	}
}
