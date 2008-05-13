﻿
package com.icg.madagascar.manager
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.icg.madagascar.base.StaticWidget;
	import com.icg.madagascar.dispatcher.MadagascarDispatcher;
	import com.icg.madagascar.events.MadagascarEvent;
	import com.icg.madagascar.model.SectionStorage;
	import com.icg.madagascar.output.Outputter;
	import com.icg.util.VariableUtil;
	
	public class URLManager extends StaticWidget
	{
		/*
		Variable Decarations
		*/
		public static  var AUTO:String = "auto";
		public static  var MANUAL:String = "manual";
		private static  var OUTPUT:Outputter = new Outputter(URLManager);
		/*
		Constructor
		*/

		public static function initialize():void
		{
			MadagascarDispatcher.addEventListener(MadagascarEvent.DO_DEFAULT, URLManager.onDoSetup, false, 1);
			URLManager.enableChangeHandler();
		}
		/*
		Set Mode
		*/
		public static function setMode($mode:String):void
		{
			switch ($mode.toLowerCase()) {
				case URLManager.AUTO :
					MadagascarDispatcher.addEventListener(MadagascarEvent.INITIALIZE_COMPLETE, URLManager.onInitializeComplete);
					MadagascarDispatcher.addEventListener(MadagascarEvent.SET_QUEUE, URLManager.onPauseChangeHandler);
					break;
				case URLManager.MANUAL :
					MadagascarDispatcher.removeEventListener(MadagascarEvent.INITIALIZE_COMPLETE, URLManager.onInitializeComplete);
					MadagascarDispatcher.removeEventListener(MadagascarEvent.SET_QUEUE, URLManager.onPauseChangeHandler);
					break;
				default :
					URLManager.OUTPUT.output("Invalid mode!","error");
					break;
			}
		}
		/*
		Enable/ Disable Change Event
		*/
		private static function enableChangeHandler()
		{
			URLManager.OUTPUT.output("Change handler enabled!")
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, URLManager.onChangeNotification);
		}
		private static function disableChangeHandler()
		{
			URLManager.OUTPUT.output("Change handler disabled!")
			SWFAddress.removeEventListener(SWFAddressEvent.CHANGE, URLManager.onChangeNotification);
		}
		/*
		
		
		Wrapper functions
		
		
		*/
		public static function getTitle():String
		{
			return SWFAddress.getTitle();
		}
		public static function setTitle($title:String):void
		{
			SWFAddress.setTitle($title);
		}
		/*
		
		Status bar functions 
		
		*/
		public static function getStatus():String
		{
			return SWFAddress.getStatus();
		}
		public static function setStatus($status:String):void
		{
			SWFAddress.setStatus($status);
		}
		public static function resetStatus():void
		{
			SWFAddress.resetStatus();
		}
		/*
		
		Path functions
		
		*/
		public static function getPath():String
		{
			return SWFAddress.getPath();
		}
		public static function setPath($path:String):void
		{
			SWFAddress.setValue("/" + $path);
		}
		public static function clearPath():void
		{
			SWFAddress.setValue("")
		}
		public static function getCleanPath():String
		{
			var strPath:String = URLManager.getPath();
			var numStartIndex:int  = (strPath.charAt(0) == "/") ? 1 : 0;
			var numLastIndex:int = (strPath.charAt(strPath.length -1) == "/") ? strPath.length -1 : strPath.length
			var strTempPath:String = strPath.substring(numStartIndex, numLastIndex)
			var strCleanPath:String = (strTempPath == "/") ? null : strTempPath ;
			return strCleanPath;
		}
		/*
		
		Query string functions
		
		*/
		public static function setQueryString($query:String):void
		{
			var strAddress:String=URLManager.getAddress();
			if (strAddress.indexOf("?") != -1) {
				var strBeginning:String=strAddress.substr(0,strAddress.indexOf('?'));
				URLManager.setAddress(strBeginning + $query);
			} else {
				URLManager.setAddress(strAddress + "?" + $query);
			}
		}
		public static function getQueryString():String
		{
			return SWFAddress.getQueryString();
		}
		public static function clearQueryString():void
		{
			var strAddress:String=URLManager.getAddress();
			var arrDivision:Array=strAddress.split("?");
			URLManager.setAddress(arrDivision[0]);
		}
		/*
		
		Single Parameter functions
		
		*/
		public static function getParameter($parameter:String):String
		{
			return SWFAddress.getParameter($parameter);
		}
		public static function populateParameters($query:Object):void
		{
			URLManager.clearQueryString();
			for (var q in $query) {
				URLManager.addParameter(q,$query[q]);
			}
		}
		public static function addParameter($parameter:String,$value:String):void
		{
			var strAddress:String=URLManager.getAddress();
			if (strAddress.indexOf("?") != -1) {
				strAddress+= "&" + $parameter + "=" + $value;
			} else {
				strAddress+= "?" + $parameter + "=" + $value;
			}
			URLManager.setAddress(strAddress);
		}
		public static function setParameter($parameter:String,$value:String):void
		{
			var objQuery:Object=URLManager.getParameterObject();
			if (objQuery[$parameter] != undefined) {
				objQuery[$parameter]=$value;
				URLManager.populateParameters(objQuery);
			} else {
				URLManager.addParameter($parameter,$value);
			}
		}
		public static function getParameterObject():Object
		{
			var strQuery:String=URLManager.getQueryString();
			var objQuery:Object=new Object;
			var arrValuePairs:Array=strQuery.split("&");
			var tmpPreviousResult:*;
			for (var i in arrValuePairs) {
				var arrPair:Array=arrValuePairs[i].split("=");


				var tmpValueName:String = arrPair[0];
				var tmpValueClean:* = VariableUtil.sanitize(arrPair[1]);

				// Look for an existing value by that name

				if (objQuery[tmpValueName] != null) {

					//If found and is Array push value else, create array and push value

					if (objQuery[tmpValueName] is Array) {
						objQuery[tmpValueName].push(tmpValueClean);
					} else {
						//create new array
						tmpPreviousResult = objQuery[tmpValueName];
						objQuery[tmpValueName] = new Array();
						objQuery[tmpValueName].push(tmpPreviousResult);
						objQuery[tmpValueName].push(tmpValueClean);
					}
				} else {
					objQuery[tmpValueName]=tmpValueClean;
				}
			}
			return objQuery;
		}
		/*
		Returns all the names of the query string parameters
		*/
		public static function getParameterNames():Array
		{
			return SWFAddress.getParameterNames();
		}
		/*
		Clears a single parameter
		*/
		public static function clearParameter($parameter:String):void
		{
			var objQuery:Object=URLManager.getParameterObject();
			delete objQuery[$parameter];
			URLManager.populateParameters(objQuery);
		}
		/*
		Event Handlers
		*/
		public static function onDoSetup($event:MadagascarEvent):void
		{
			MadagascarDispatcher.removeEventListener(MadagascarEvent.DO_DEFAULT, URLManager.onDoSetup);
			URLManager.setMode(URLManager.AUTO);
		}	
		private static function onChangeNotification($event:SWFAddressEvent)
		{
			var objDetails:Object = new Object();
			objDetails.query = URLManager.getParameterObject();
			objDetails.path = URLManager.getCleanPath();
			MadagascarDispatcher.dispatchEvent(new MadagascarEvent(MadagascarEvent.URL_CHANGE,URLManager, objDetails));
		}		
		private static function onInitializeComplete($event:MadagascarEvent)
		{
			URLManager.clearPath();
			URLManager.setPath(SectionStorage.current.alias);
			SWFAddress.setStatus("Ready");
			URLManager.enableChangeHandler();		
		}
		private static function onPauseChangeHandler($event:MadagascarEvent)
		{
			URLManager.disableChangeHandler();
		}
		/*
		
		Address functions 
		
		*/
		/*
		Returns everything currently in the address bar
		*/
		public static function getAddress():String
		{
			return SWFAddress.getValue();
		}
		public static function setAddress($value:String):void
		{
			SWFAddress.setValue($value);
		}
		public static function clearAddress($value:String):void
		{
			URLManager.setAddress("");
		}
	}
}