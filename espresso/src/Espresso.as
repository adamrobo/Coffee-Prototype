package
{
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import game.Assets;
import game.C;

import net.flashpunk.Engine;
import net.flashpunk.FP;

public class Espresso extends Engine
{
	[SWF(width="320", height="480")]
	
	public function Espresso()
	{
		super(320, 480);
		FP.screen.color = 0xede7d5;
	}
	
	public override function init():void
	{
		trace("FP Version",FP.VERSION,"started.");
		
		// Setup our stage modes.
		FP.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		// Load in our Pour and Mix data from XML
		Assets.GetPoursFromXML();
		Assets.GetMixesFromXML();
		
		// Enable our debug console.
		//FP.console.enable();
		
		// Enter our entry world.
		FP.world = new C.ENTRY();
	}
}
}