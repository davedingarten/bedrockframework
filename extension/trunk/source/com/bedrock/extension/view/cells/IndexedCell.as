package com.bedrock.extension.view.cells
{
	
	import com.bedrock.framework.engine.data.BedrockData;
	import com.bedrock.framework.plugin.util.VariableUtil;
	
	import mx.controls.listClasses.IListItemRenderer;

	public class IndexedCell extends GenericCheckBoxCell implements IListItemRenderer
	{
		public function IndexedCell()
		{
		}
		
		private function _applyToolTip():void
		{
			if ( this.checkBox.selected ) {
					this.checkBox.toolTip = "Remove from index list.";
			} else {
					this.checkBox.toolTip = "Add to index list.";
			}
		}
		
		public function update():void
		{
			this._applyToolTip();
			this.rawData.@[ BedrockData.INDEXED ] = this.checkBox.selected;
		}
		public function populate( $data:Object ):void
		{
			this.checkBox.visible = true;
			this.checkBox.selected = VariableUtil.sanitize( this.rawData.@[ BedrockData.INDEXED ] );
			this._applyToolTip();
		}
		
	}
}