﻿/** * Bedrock Framework for Adobe Flash ©2007-2008 *  * Written by: Alex Toledo * email: alex@builtonbedrock.com * website: http://www.builtonbedrock.com/ * blog: http://blog.builtonbedrock.com/ *  * By using the Bedrock Framework, you agree to keep the above contact information in the source code. **/package com.bedrockframework.engine{	import com.bedrockframework.core.base.MovieClipWidget;	import com.bedrockframework.engine.manager.AssetManager;		public class AssetBuilder extends MovieClipWidget	{		public function AssetBuilder()		{			this["initialize"]();		}				protected function addView($name:String, $class:Class):void		{			BedrockEngine.getInstance().assetManager.addView($name, $class);		}		protected function addPreloader($name:String, $class:Class):void		{			BedrockEngine.getInstance().assetManager.addPreloader($name, $class);		}		protected function addBitmap($name:String, $class:Class):void		{			BedrockEngine.getInstance().assetManager.addBitmap($name, $class);		}		protected function addSound($name:String, $class:Class):void		{			BedrockEngine.getInstance().assetManager.addSound($name, $class);		}	}}