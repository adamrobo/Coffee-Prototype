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
		
		[ Embed( source = 'S.mp3' ) ] private const SFillSound : Class;
		[ Embed( source = 'A.mp3' ) ] private const AFillSound : Class;
		[ Embed( source = 'B.mp3' ) ] private const BFillSound : Class;
		[ Embed( source = 'C.mp3' ) ] private const CFillSound : Class;
		[ Embed( source = 'D.mp3' ) ] private const DFillSound : Class;
		[ Embed( source = 'F.mp3' ) ] private const FFillSound : Class;
		[ Embed( source = 'fillup.mp3' ) ] private const FillUpSound : Class;
		
		protected var _SfillSound : Sfx;
		protected var _AfillSound : Sfx;
		protected var _BfillSound : Sfx;
		protected var _CfillSound : Sfx;
		protected var _DfillSound : Sfx;
		protected var _FfillSound : Sfx;
		protected var _fillUpSound : Sfx;
		
		public function Player()
		{			
			playerImage = new Image(new BitmapData(240, 320));
			playerImage.color = 0x693426;
			graphic = playerImage;
			setHitbox(240,320);
			
			y = 320;
			
			_SfillSound = new Sfx( SFillSound );
			_AfillSound = new Sfx( AFillSound );
			_BfillSound = new Sfx( BFillSound );
			_CfillSound = new Sfx( CFillSound );
			_DfillSound = new Sfx( DFillSound );
			_FfillSound = new Sfx( FFillSound );
			_fillUpSound = new Sfx( FillUpSound );

		}
		
		public override function update():void
		{
			// Checking player input and cycling through game states
			
			if(Input.pressed(Key.X) && fillingState == 0)
			{
				fillingState = 1; //filling up
				_fillUpSound.play(); // play fill up sound
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
				_fillUpSound.stop(); // stop fill up sound
				score = y - fillLineYPosition; // Check Score
				score = Math.abs(score); // make score positive
				score = 100 - score // set score on typical 100 point scale
				if(score >= 98) // convert score to letter grade
				{
					scoreGrade = "PERFECT!";
					_SfillSound.play(); // play S fill line sound
				} else if(score >= 87) {
					scoreGrade = "GREAT";
					_AfillSound.play(); // play A fill line sound
				} else if (score >= 75) {
					scoreGrade = "OK";
					_BfillSound.play(); // play B fill line sound
				}  else if (score >= 70) {
					scoreGrade = "OK";
					_BfillSound.play(); // play C fill line sound
				}  else if ( score >= 40 ) {
					scoreGrade = "BAD";
					_DfillSound.play(); // play D fill line sound
				} else {
					scoreGrade = "HORRIBLE";
					_FfillSound.play(); // play F fill line sound
				}
				scoreArray.push(scoreGrade); // Store scoreGrade in array
				
				y = 320; // Reset coffee to bottom of screen
				fillLineYPosition = 100 + FP.rand(100); // reset fill line position
				
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