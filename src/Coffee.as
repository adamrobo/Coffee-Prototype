package
{
	import flash.display.StageQuality;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="480", height="640")]
	public class Coffee extends Engine
	{
		public function Coffee()
		{
			super( 240, 320 );
			FP.screen.scale = 2;
			FP.console.enable();
			
			FP.screen.color = 0x007042; //set background color
		}
		
		public override function init():void
		{
			trace("FlashPunk " + FP.VERSION + " started!");
			FP.screen.scale = 2;
			FP.stage.quality = StageQuality.LOW;
			FP.world = new GameWorld();
		}
	}
}