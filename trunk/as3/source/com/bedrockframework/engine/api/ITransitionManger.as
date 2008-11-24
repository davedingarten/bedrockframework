package com.bedrockframework.engine.api
{
	import com.bedrockframework.plugin.view.IView;
	import com.bedrockframework.plugin.loader.VisualLoader;
	
	public interface ITransitionManger
	{
		function initialize():void		
		function reset():void		
		/*
		Set the current container to load content into
	 	*/
	 	function set siteLoader($loader:VisualLoader):void
		function get siteLoader():VisualLoader
		function set pageLoader($loader:VisualLoader):void
		function get pageLoader():VisualLoader		
		function get siteView():IView
		function get pageView():IView
	}
}