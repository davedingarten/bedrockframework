package com.autumntactics.remoting
{
	import com.autumntactics.bedrock.base.BasicWidget;
	
	import flash.net.Responder;
	
	public class Delegate extends BasicWidget
	{
		/*
		Variable Declarations
		*/
		public var responder:IResponder;
		/*
		Constructor
		*/
		public function Delegate($responder:IResponder)
		{
			this.responder = $responder;
		}
		
	}
}