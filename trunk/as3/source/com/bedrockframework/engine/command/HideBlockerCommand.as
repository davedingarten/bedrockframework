﻿package com.bedrockframework.engine.command
{
	import com.bedrockframework.core.command.*;
	import com.bedrockframework.core.event.GenericEvent;
	import com.bedrockframework.engine.manager.ContainerManager;

	public class HideBlockerCommand extends Command implements ICommand
	{
		public function HideBlockerCommand()
		{
		}
		public  function execute($event:GenericEvent):void
		{
			ContainerManager.getContainer("blocker").hide();
		}
	}

}