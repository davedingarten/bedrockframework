﻿package com.bedrockframework.engine{	import com.bedrockframework.core.base.MovieClipWidget;	import com.bedrockframework.engine.manager.AssetManager;		public class AssetBuilder extends MovieClipWidget	{		public function AssetBuilder()		{			AssetManager.initialize();			this.initialize();		}		public function initialize():void		{		}		protected function addView($name:String, $class:Class):void		{			AssetManager.addView($name, $class);		}		protected function addPreloader($name:String, $class:Class):void		{			AssetManager.addPreloader($name, $class);		}		protected function addBitmap($name:String, $class:Class):void		{			AssetManager.addBitmap($name, $class);		}		protected function addSound($name:String, $class:Class):void		{			AssetManager.addSound($name, $class);		}	}}