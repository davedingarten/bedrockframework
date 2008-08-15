﻿package com.yourdomain.project.template.view
{
	import caurina.transitions.Tweener;
	
	import com.bedrockframework.core.base.MovieClipWidget;
	import com.bedrockframework.engine.event.BedrockEvent;
	import com.bedrockframework.engine.view.*;
	
	import flash.text.TextField;
	
	public class DefaultPreloaderView extends View implements IPreloader
	{
		/*
		* Variable Declarations
		*/
		public var txtDisplay:TextField;
		/*
		* Constructor
		*/
		public function DefaultPreloaderView()
		{
			this.alpha = 0 ;
		}
		/*
		* Basic view functions
	 	*/
		public function initialize($properties:Object=null):void
		{
			this.displayProgress(0);
			this.x=this.stage.stageWidth / 2;
			this.y=this.stage.stageHeight / 2;
			this.initializeComplete();
		}
		public function intro($properties:Object=null):void
		{
			Tweener.addTween(this, {alpha:1, transition:"linear", time:1, onComplete:this.introComplete});
			//this.introComplete();
		}
		public function displayProgress($percent:uint):void
		{
			this.txtDisplay.text=$percent + " %";
		}
		public function outro($properties:Object=null):void
		{
			Tweener.addTween(this, {alpha:0, transition:"linear", time:1, onComplete:this.outroComplete});
			//this.outroComplete();
		}
		
		public function clear():void
		{
		}
		

	}
}