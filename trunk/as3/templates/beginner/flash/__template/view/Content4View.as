package __template.view
{
	import com.bedrock.framework.engine.view.BedrockContentView;
	import com.bedrock.framework.plugin.view.IView;
	import com.greensock.TweenLite;
	
	import flash.text.TextField;
	
	public class Content4View extends BedrockContentView implements IView
	{
		/*
		Variable Declarations
		*/
		public var label:TextField;
		/*
		Constructor
		*/
		public function Content4View()
		{
			this.alpha = 0;
		}
		/*
		Basic view functions
	 	*/
		public function initialize($data:Object=null):void
		{
			this.status( "Initialize" );
			this.label.text = this.properties.label;
			this.initializeComplete();
		}
		public function intro($data:Object=null):void
		{
			this.status( "Intro" );
			TweenLite.to(this, 1, { alpha:1, onComplete:this.introComplete } );
			//this.introComplete();
		}
		public function outro($data:Object=null):void
		{
			TweenLite.to(this, 1, { alpha:0, onComplete:this.outroComplete } );
			//this.outroComplete();
		}
		public function clear():void
		{
			this.clearComplete();
		}
		/*
		Event Handlers
		*/
	}
}