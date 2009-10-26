﻿package __template.view
{
	import com.bedrockframework.engine.BedrockEngine;
	import com.bedrockframework.engine.data.BedrockData;
	import com.bedrockframework.engine.view.BedrockView;
	import com.bedrockframework.engine.view.IPreloader;
	
	import flash.text.TextField;
	
	import gs.TweenLite;
	import gs.easing.Quad;
	
	public class DefaultPreloaderView extends BedrockView implements IPreloader
	{
		/*
		Variable Declarations
		*/
		public var display:TextField;
		public var label:TextField;
		/*
		Constructor
		*/
		public function DefaultPreloaderView()
		{
			this.alpha=0;
		}
		/*
		* Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(0);
			this.label.text = this.queue.label;
			
			this.x = BedrockEngine.config.getSettingValue( BedrockData.ROOT_WIDTH ) / 2;
			this.y = BedrockEngine.config.getSettingValue( BedrockData.ROOT_HEIGHT ) / 2;
			
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			TweenLite.to(this, 1, {alpha:1, ease:Quad.easeOut, onComplete:this.introComplete});
			//this.introComplete();
		}
		public function displayProgress($percent:uint):void
		{
			this.display.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			TweenLite.to(this, 1, {alpha:0, ease:Quad.easeOut, onComplete:this.outroComplete});
			//this.outroComplete();
		}
		public function clear():void
		{
		}

	}
}