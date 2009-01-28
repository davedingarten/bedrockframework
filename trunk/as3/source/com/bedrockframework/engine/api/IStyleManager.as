package com.bedrockframework.engine.api
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	public interface IStyleManager
	{
		/*
		Parse the StyleSheet
		*/
		function parseCSS($stylesheet:String):void
		/*
		Apply Tag
		*/
		function applyTag($text:String, $tag:String):String
		/*
		Apply Style
		*/
		function applyStyle($text:String, $style:String):String
		/*
		Get Style Object
		*/
		function getStyle($style:String):Object
		/*
		Get Format Object
		*/
		function getFormat($style:String):TextFormat
		/*
		Property Definitions
		*/
		function get styleNames():Array
		function get styleSheet():StyleSheet
	}
}