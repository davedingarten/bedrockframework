﻿package com.bedrockframework.plugin.data
{
	public class StageRelationData
	{
		public static  const LEFT:String="left";
		public static  const RIGHT:String="right";
		public static  const CENTER:String="center";
		public static  const BOTTOM:String="bottom";
		public static  const TOP:String="top";
		public static  const NONE:String="none";
		
		public var horizontalAlignment:String;
		public var verticalAlignment:String;
		public var horizontalOffset:Number;
		public var verticalOffset:Number;
		
		public var widthResize:Boolean;
		public var heightResize:Boolean;
		
		public var alias:String;
		public var target:*;
		
		public var positionBasedOnSize:Boolean;

		public function StageRelationData( $alias:String )
		{
			this.alias = $alias;
			this.widthResize = false;
			this.heightResize = false;
			this.horizontalAlignment = StageRelationData.NONE;
			this.verticalAlignment = StageRelationData.NONE;
			
			this.positionBasedOnSize = false;
		}
	}
}