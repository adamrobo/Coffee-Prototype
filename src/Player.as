package
{
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	public class Player extends Entity
	{
		protected var playerImage:Image;
		protected var PLAYER_VSPEED:int = 0;
		protected const PLAYER_VACCEL:int = 10;
		protected const friction:int = 10;
		protected var score:int = 0;
		protected var fillingState:int = 0; // 0 == done, 1 == filling, 2 == scoring
		
		public function Player()
		{
			playerImage = new Image(new BitmapData(240, 320));
			playerImage.color = 0x693426;
			graphic = playerImage;
			setHitbox(240,320);
			
			y = 320;
		}
		
		public override function update():void
		{
			// Checking player input and cycling through game states
			
			if(Input.pressed(Key.X) && fillingState == 0){
				fillingState = 1; //filling up
			}

			if(fillingState == 1){
				PLAYER_VSPEED += PLAYER_VACCEL; // Move coffee up
				if (PLAYER_VSPEED > 200) PLAYER_VSPEED = 200; // Cap speed at 200
			}
			
			if(Input.released(Key.X) && fillingState == 1){
				fillingState = 2; // scoring
			}			

			if(fillingState == 2){
				if(PLAYER_VSPEED > 0) PLAYER_VSPEED -= friction; // Slow down coffee	
				if (PLAYER_VSPEED < 0) PLAYER_VSPEED = 0; // Lowest possible speed is 0,
			}

			if(fillingState == 2 && PLAYER_VSPEED == 0){
				score = y - 100; // Check Score
				FP.log(score); // Output Score
				y = 320; // Reset coffee to bottom of screen
				fillingState = 0; // done
			}
			
			y -= PLAYER_VSPEED * FP.elapsed; // Apply physics.
			
			super.update(); // Update parent shit.
		}		
	}
}