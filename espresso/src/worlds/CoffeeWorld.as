package worlds
{
	import flash.display.BitmapData;
	
	import game.C;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	
	public class CoffeeWorld extends World
	{
		protected var currentFillLevel:Number;
		protected var fillVelocity:Number;
		protected var fillDisplay:Entity;
		protected var shots:int;
		protected var partsPerShot:Vector.<int>;
		
		
		public function CoffeeWorld()
		{
			currentFillLevel = FP.height;
			fillVelocity = 0;
			Input.define("fill", Key.SPACE, Key.Z);
			Input.define("next", Key.N, Key.ENTER);
			shots = FP.rand(3) + 1;
			partsPerShot = new Vector.<int>(shots);
			for(var i:uint = 0; i < shots; i++)
			{
				partsPerShot[i] = FP.rand(2)+1;
			}
			trace("CoffeeWorld entered.");
			trace(shots,"shots with a mix of", partsPerShot);
			super();
		}
		
		public override function begin():void
		{
			fillDisplay = new Entity(0,FP.height,new Image(new BitmapData(FP.width, FP.height, true, 0xcc54461e)));
			var lastHeight:uint = FP.height;
			for(var i:uint = 0; i < shots; i++)
			{
				addGraphic(new Stamp(new BitmapData(FP.width,3,true,0xaa000000)),1,0,lastHeight - partsPerShot[i] * C.HEIGHT_SHOT - 1);
				lastHeight -= partsPerShot[i] * C.HEIGHT_SHOT;
			}
			add(fillDisplay);
			trace(fillDisplay);
			super.begin();
		}
		
		public override function update():void
		{
			if(Input.check("fill"))
			{
				// TODO: Update our fill.
				fillVelocity += C.A_FILL * FP.elapsed;
			}
			else
			{
				fillVelocity -= (fillVelocity * C.DAMPING_FILL);
			}
			
			if(Input.pressed("next"))
			{
				FP.world = new CoffeeWorld();
			}
			
			currentFillLevel -= fillVelocity * FP.elapsed;
			fillDisplay.y = Math.round(currentFillLevel);
			
			super.update();
		}
	}
}