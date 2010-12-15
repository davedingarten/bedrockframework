package com.bedrock.extension.view.cells
{
	
	import com.bedrock.extension.controller.ProjectController;
	import com.bedrock.extension.event.ExtensionEvent;
	import com.bedrock.framework.core.dispatcher.BedrockDispatcher;
	import com.bedrock.framework.core.logging.Logger;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import flash.events.Event;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class PublishFLACell extends GenericCheckBoxCell implements IListItemRenderer
	{
		private var _xmlData:XML;
		
		public function PublishFLACell()
		{
		}

		private function _applyToolTip():void
		{
			if ( this.checkBox.selected ) {
					this.checkBox.toolTip = "Remove document from publish list.";
			} else {
					this.checkBox.toolTip = "Add document to publish list.";
			}
		}
		
		public function update():void
		{
			this._applyToolTip();
			this._xmlData.@publish = this.checkBox.selected;
			
				Logger.debug( this._xmlData );
			BedrockDispatcher.dispatchEvent( new ExtensionEvent( ExtensionEvent.SAVE_PROJECT, this ) );
		}
		
		public function populate( $data:Object ):void
		{
			if ( $data != null && $data.@type == ".fla" ) {
				
				this._xmlData = ProjectController.getInstance().projectXML..file.( @name == $data.@name )[ 0 ];
				this.checkBox.enabled = true;
				this.checkBox.visible = true;
				this.checkBox.selected = VariableUtil.sanitize( this._xmlData.@publish );
				this._applyToolTip();
				
				if ( this._xmlData.@name == "shell" ) {
					this.checkBox.selected = true;
					this.checkBox.enabled = false;
					this.checkBox.toolTip = "";
				}
			
			} else {
				this._xmlData = null;
				this.checkBox.visible = false;
			}
		}
		
	}
}