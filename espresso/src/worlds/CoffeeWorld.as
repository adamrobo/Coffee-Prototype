package worlds
{
	import drinks.Mix;
	import drinks.Pour;
	
	import flash.display.BitmapData;
	
	import game.Assets;
	import game.C;
	import game.V;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class CoffeeWorld extends World
	{
		protected var currentMix:Mix;
		
		
		public function CoffeeWorld()
		{
			Input.define("fill", Key.SPACE, Key.Z);
			Input.define("next", Key.N, Key.ENTER);
			currentMix = Assets.CreateMixByID(FP.choose(Assets.Mixes));
			
			trace("CoffeeWorld entered.");
			super();
		}
		
		public override function begin():void
		{
			currentMix.createMixGuides(this);
			V.SetActivePour(Pour(add(currentMix.getNextPour())));
			super.begin();
		}
		
		public override function update():void
		{
			if(V.ActivePour != null)
			{
				if (Input.pressed("fill"))
				{
					// We've begun to fill our cup.
					V.ActivePour.beginPour();
				}
				else if (Input.released("fill"))
				{
					// We've finished filling our cup.
					V.ActivePour.endPour();
					
					// Now, we need to add our next Pour.
					if (currentMix.getRemainingPours() > 0)
					{
						V.SetActivePour(Pour(add(currentMix.getNextPour())));
					}
					else
					{
						trace("Pour over.");
						V.SetActivePour(null);
					}
				}
			}
			
			if(Input.pressed("next"))
			{
				FP.world = new CoffeeWorld();
			}
						
			super.update();
		}
	}
}