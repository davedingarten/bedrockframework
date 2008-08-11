﻿package com.bedrockframework.plugin.storage
{
	import flash.utils.Proxy;
	
	public class ArrayBrowser extends Proxy
	{
		import com.bedrockframework.plugin.util.MathUtil;
		import com.bedrockframework.plugin.util.ArrayUtil;
		/*
		Variable Declarations
		*/
		private var _arrData:Array;
		private var _numSelectedIndex:Number;
		private var _bolWrapIndex:Boolean;
		private var _numLimit:Number;
		private var _bolAllowDuplicates:Boolean;
		/*
		Constructor
		*/
		public function ArrayBrowser($data:Array = null)
		{
			this.data = $data;
			this._bolWrapIndex=false;
			this.reset();
		}
		/*
		Clear
		*/
		public function clear():void
		{
			var numLength:Number=this._arrData.length;
			for (var i=0; i < numLength; i++) {
				this._arrData.pop();
			}
			this.reset();
		}
		/*
		Reset Selections
		*/
		public function reset():void
		{
			this._numSelectedIndex = 0;
		}
		/*
		Returns a copy of the array
		*/
		public function duplicate():Array
		{
			return ArrayUtil.duplicate(this._arrData);
		}
		/*
		Insert new data at index
		*/
		public function insert($location:Number,$item):Array
		{
			return ArrayUtil.insert(this._arrData,$location,$item);
		}
		/*
		Move item to a different location
		*/
		public function move($index:Number,$location:Number):Array
		{
			return ArrayUtil.move(this._arrData,$index,$location);
		}
		/*
		Remove item at index
		*/
		public function remove($index:Number):*
		{
			return ArrayUtil.remove(this._arrData,$index);
		}
		/*
		Add to end
		*/
		public function automaticPush($array:Array)
		{
			var numLength:Number=$array.length;
			for (var i=0; i < numLength; i++) {
				this._arrData.push($array[i]);
			}
		}
		/*
		Loop through an array unshift each item in
		*/
		public function automaticUnshift($array:Array)
		{
			var numLength:Number=$array.length;
			for (var i=0; i < numLength; i++) {
				this._arrData.unshift($array[i]);
			}
		}
		/*
		Wrappers 
		*/
		public function push(...$arguments:Array):void
		{
			var numLength:int = $arguments.length;
			for (var a:int = 0 ; a < numLength; a++) {
				this._arrData.push($arguments[a]);
			}			
			if (this._numLimit != 0) {
				if (this._arrData.length > this._arrData._numLimit) {
					var numLoop:Number=this._numLimit - this._arrData.length;
					for (var i=0; i < numLoop; i++) {
						this._arrData.shift();
					}
				}
			}
		}
		public function unshift(...$arguments:Array):void
		{
			var numLength:int = $arguments.length;
			for (var a:int = 0 ; a < numLength; a++) {
				this._arrData.unshift($arguments[a]);
			}
			if (this._numLimit != 0) {
				if (this._arrData.length > this._numLimit) {
					var numLoop:Number=this._numLimit - this._arrData.length;
					for (var i=0; i < numLoop; i++) {
						this._arrData.pop();
					}
				}
			}
		}
		/*
		Return item at location
		*/
		public function getItemAt($location:Number):*
		{
			if (this._bolWrapIndex){
				return this._arrData[MathUtil.wrapIndex($location, this._arrData.length, true)];
			}else{
				try{
					return this._arrData[$location];
				} catch($error:Error){
					return null
				}					
			}		
		}
		/*
		Increment selected index
		*/
		public function selectNext():*
		{
			return this.setSelected(this._numSelectedIndex + 1);
		}
		/*
		Decrement selected index
		*/
		public function selectPrevious():*
		{
			return this.setSelected(this._numSelectedIndex - 1);
		}
		/*
		Select current index
		*/
		public function setSelected($index:Number):*
		{
			//check for wrapping
			var numLength:Number=this._arrData.length;
			this._numSelectedIndex=MathUtil.wrapIndex($index,numLength,this._bolWrapIndex);
			return this.getSelected();
		}
		/*
		Return selected item from the array
		*/
		public function getSelected():*
		{
			return this.getItemAt(this._numSelectedIndex);
		}
		
		/*
		Select a random item in the array
		*/
		public function selectRandom()
		{
			if (this._arrData.length > 0) {
				return this.setSelected(ArrayUtil.randomIndex(this._numSelectedIndex,this._arrData.length));
			}
		}
		/*
		* Has more items
		*/
		public function hasNext():Boolean
		{
			if (this._bolWrapIndex) {			
				return true;
			}
			if ((this._numSelectedIndex + 1)  >= this._arrData.length) {
				return false;
				}else{
				return true;
			}			
		}
		public function hasPrevious():Boolean
		{
			if (this._bolWrapIndex) {			
				return true;
			}
			if ((this._numSelectedIndex - 1)  < 0) {
				return false;
				}else{
				return true;
			}	
		}
		/*
		Get random items based on a total
		*/
		public function getRandomItems($total:Number)
		{
			if (this._arrData.length > 0) {
				return ArrayUtil.getRandomItems(this._arrData,$total);
			}
		}
		/*
		Get object properties from array
		*/
		public function getProperties($property:String):Array
		{
			var numLength:Number=this._arrData.length;
			var arrReturn:Array=new Array;
			for (var i=0; i < numLength; i++) {
				arrReturn.push(this._arrData[i][$property]);
			}
			return arrReturn;
		}
		/*
		Search: Returns array with results
		*/
		public function filter($value:*,$field:String=null):Array
		{
			return ArrayUtil.filter(this._arrData,$value,$field);
		}
		/*
		Search for and remove an item from an array
		*/
		public function filterAndRemove($value:*,$field:String=null):Array
		{
			return ArrayUtil.filterAndRemove(this._arrData,$value,$field);;
		}
		/*
		Search: Returns Single Index
		*/
		public function findIndex($value:*,$field:String=null):Number
		{
			return ArrayUtil.findIndex(this._arrData,$value,$field);
		}
		/*
		Search: Returns Single Item
		*/
		public function findItem($value:*,$field:String=null):*
		{
			return ArrayUtil.findItem(this._arrData,$value,$field);
		}
		/*
		Search: Finds a string within a field
		*/
		public function findContaining($value:*,$field:String=null):*
		{
			return ArrayUtil.findContaining(this._arrData,$value,$field);
		}
		/*
		Search: Returns true or false wether a value exists or not
		*/
		public function containsItem($value:*,$field:String=null):Boolean
		{
			return ArrayUtil.containsItem(this._arrData,$value,$field);
		}
		/*
		Search: Selects and Returns a Single Item
		*/
		public function findAndSelect($value:*,$field:String=null):*
		{
			return this.setSelected(ArrayUtil.findIndex(this._arrData,$value,$field));
		}
		
		/*
		Set/ Get data
		*/
		public function set data($data:Array):void
		{
			this._arrData = $data;
			this.reset();
		}
		public function get data():Array
		{
			return this._arrData;
		}
		/*
		Set the limit for the number if items that should be in the array
		*/
		public function set itemLimit($limit:Number):void
		{
			this._numLimit=$limit;
		}
		public function get itemLimit():Number
		{
			return this._numLimit;
		}
		/*
		Return the last index from the array
		*/
		public function get lastIndex():Number
		{
			return (this._arrData.length - 1);
		}
		/*
		Allow for duplicate entries
		*/
		public function set allowDuplicates($status:Boolean):void
		{
			this._bolAllowDuplicates=$status;
		}
		public function get allowDuplicates():Boolean
		{
			return this._bolAllowDuplicates;
		}
		/*
		Set the wrapping properties of the array
		*/
		public function set wrapIndex($status:Boolean)
		{
			this._bolWrapIndex=$status;
		}
		public function get wrapIndex():Boolean
		{
			return this._bolWrapIndex;
		}
		/*
		Return selected item from the array
		*/
		public function get selectedIndex():Number
		{
			return this._numSelectedIndex;
		}
		public function get selectedItem():*
		{
			return this.getSelected();
		}
	}
}