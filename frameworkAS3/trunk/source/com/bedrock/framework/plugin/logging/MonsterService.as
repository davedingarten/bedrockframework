﻿package com.bedrock.framework.plugin.logging
{
	import com.bedrock.framework.core.logging.LogData;
	/**
	 * @private
	 */
	import nl.demonsters.debugger.MonsterDebugger;

	public class MonsterService implements ILoggingService
	{
		private var _level:uint;
		
		public function MonsterService()
		{
		}
		
		public function initialize( $logLevel:uint, $detailDepth:uint ):void
		{
			this.level = $logLevel;
		}
		
		public function log( $trace:*, $data:LogData ):void
		{
			MonsterDebugger.trace( this, $trace, $data.categoryColor );
		}
		
		public function set level( $level:uint ):void
		{
			this._level = $level;
		}
		
		public function get level():uint
		{
			return this._level;
		}
		
	}
}