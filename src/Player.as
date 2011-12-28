package
{
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	
	public class Player extends Entity
	{
		protected var playerImage:Image;
		protected var PLAYER_VSPEED:int = 0;
		protected const PLAYER_MAXVSPEED:int = 250;
		protected const PLAYER_VACCEL:int = 20;
		protected const friction:int = 10;
		public var score:int = 0;
		public var scoreGrade:String = "";
		public var fillingState:int = 0; // 0 == done, 1 == filling, 2 == scoring, 3 == scorecard
		protected var scoreArray:Array = [];
		
		public var fillLineYPosition:int = 100;
		
		[ Embed( source = 'coin.mp3' ) ] private const FillCompleteSound : Class;
		
		protected var _fillSound : Sfx;
		
		public function Player()
		{			
			playerImage = new Image(new BitmapData(240, 320));
			playerImage.color = 0x693426;
			graphic = playerImage;
			setHitbox(240,320);
			
			y = 320;
			
			_fillSound = new Sfx( FillCompleteSound );

		}
		
		public override function update():void
		{
			// Checking player input and cycling through game states
			
			if(Input.pressed(Key.X) && fillingState == 0)
			{
				fillingState = 1; //filling up
			}

			if(fillingState == 1)
			{
				PLAYER_VSPEED += PLAYER_VACCEL; // Move coffee up
				if (PLAYER_VSPEED > PLAYER_MAXVSPEED) PLAYER_VSPEED = PLAYER_MAXVSPEED; // Cap speed at PLAYER_MAXVSPEED
			}
			
			if(Input.released(Key.X) && fillingState == 1)
			{
				fillingState = 2; // scoring
			}			

			if(fillingState == 2)
			{
				if(PLAYER_VSPEED > 0) PLAYER_VSPEED -= friction; // Slow down coffee	
				if (PLAYER_VSPEED < 0) PLAYER_VSPEED = 0; // Lowest possible speed is 0,
			}

			if(fillingState == 2 && PLAYER_VSPEED == 0)
			{
				score = y - fillLineYPosition; // Check Score
				score = Math.abs(score); // make score positive
				score = 100 - score // set score on typical 100 point scale
				if(score == 100) // convert score to letter grade
				{
					scoreGrade = "S";
				} else if(score >= 90) {
					scoreGrade = "A";
				} else if (score >= 80) {
					scoreGrade = "B";
				}  else if (score >= 70) {
					scoreGrade = "C";
				}  else if ( score >= 60 ) {
					scoreGrade = "D";
				} else {
					scoreGrade = "F";
				}
				scoreArray.push(scoreGrade); // Store scoreGrade in array
				
				_fillSound.play(); // play fill line sound
				y = 320; // Reset coffee to bottom of screen
				fillLineYPosition = 100 + FP.rand(150); // reset fill line position
				
				if(scoreArray.length < 5){
					fillingState = 0; // done
				} else {
					fillingState = 3; // scorecard
				}
			}
			
			if(fillingState == 3)
			{
				FP.log (scoreArray);
				scoreArray.splice(0,5);
				fillingState = 0;
			}
			
			y -= PLAYER_VSPEED * FP.elapsed; // Apply physics.
			
			super.update(); // Update parent shit.
		}		
	}
}