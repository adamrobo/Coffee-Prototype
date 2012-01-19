package worlds
{
import drinks.Mix;
import drinks.Pour;

import flash.display.BitmapData;

import game.Assets;
import game.C;
import game.Score;
import game.V;

import mx.core.ButtonAsset;

import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.World;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Stamp;
import net.flashpunk.graphics.Text;
import net.flashpunk.utils.Input;
import net.flashpunk.utils.Key;

public class CoffeeWorld extends World
{
	protected var _currentMix:Mix;
	protected var _currentPours:Vector.<Pour>;
	protected var _mixList:Vector.<Mix>;
	protected var _score:Score;
	protected var _mixesComplete:uint;
	
	protected var _scoreText:Text;
	protected var _nameText:Text;
	
	protected var _roundEnded:Boolean;
	
	
	public function CoffeeWorld()
	{
		// Define our inputs.
		Input.define("fill", Key.SPACE, Key.Z);
		Input.define("next", Key.N, Key.ENTER);
		
		// Create a Score to update
		_score = new Score();
		
		_scoreText = new Text(String(Math.round(_score.getTotalScore())),0,0,{color:0x4D361F});
		
		// Set the current number of mixes completed to 0.
		_mixesComplete = 0;
		_roundEnded = false;
		_mixList = new <Mix>[];
		
		trace("CoffeeWorld entered.");
		super();
	}
	
	public override function begin():void
	{
		createNewMix();
		
		super.begin();
	}
	
	protected function addNextPourToWorld():Boolean
	{
		var doesPourExist:Boolean = false;
		// If there are more Pours in the current mix, get the next one.
		if (_currentMix.getRemainingPours() > 0)
		{
			// Create a new Pour based on the next Pour in the current
			// Mix and make it the currently active Pour.
			V.SetActivePour(Pour(add(_currentMix.getNextPour())));
			
			// Add the current Pour to our list so we can check against it.
			_currentPours.push(V.ActivePour);
			
			doesPourExist = true;
		}
			
		// If there are no more Pours in the current mix, we are done
		// with that mix.
		else
		{
			V.SetActivePour(null);
			doesPourExist = false;
		}
		
		return doesPourExist;
	}
	
	protected function createNewMix():void
	{
		removeAll();
		addGraphic(_scoreText,-1,2,2);
		
		// Create a container to keep track of our current Pours.
		_currentPours = new <Pour>[];
		
		// Create a new Mix for the player to create
		_currentMix = Assets.CreateMixByID(FP.choose(Assets.Mixes));
		
		_mixList.push(_currentMix);
		
		// Display lines indicating fill levels of the Mix
		_currentMix.createMixGuides(this);
		
		var nameText:Text = new Text((_mixesComplete + 1)+". "+_currentMix.getName(),0,0,{color:0x4D361F, size:24});
		addGraphic(nameText,0,FP.width/2 - nameText.width/2, 8);
		
		addNextPourToWorld();
	}
	
	public override function update():void
	{
		if(!_roundEnded)
		{
			// Only attempt to pass input information to the active pour if it
			// is defined.
			if(V.ActivePour != null)
			{
				// If the player has pressed the FILL button, tell the active pour
				// to begin increasing its size.
				if (Input.pressed("fill") || Input.check("fill"))
				{
					V.ActivePour.beginPour();
				}
					
				// If the player has released the FILL button, tell the active pour
				// to stop increasing its size.
				else if (Input.released("fill"))
				{
					V.ActivePour.endPour();
					
					addNextPourToWorld();
				}
			}
				
			// If we don't have any active pours and our mix is empty, that means
			// we are waiting for the Mix to be scored.
			else if (_currentMix.getRemainingPours() == 0)
			{
				// Since they are chained, we only need to check the last Pour
				// in our array. If it is locked, we can go to the next Mix.
				if (_currentPours[_currentPours.length-1].getIsLocked())
				{
					// TODO: Add a delay between final Pour scoring and new Mix.
					_mixesComplete++;
					
					// If we have completed all the mixes in the round, the round
					// is over; otherwise, create another Mix.
					if (_mixesComplete >= C.COUNT_MIXES_PER_ROUND)
					{
						_roundEnded = true;
						displayScores();
					}
						
					else createNewMix();
				}
			}
		}
		else
		{
			//* Handle debug input for beginning a new CoffeeWorld.
			if(Input.pressed("next"))
			{
				FP.world = new CoffeeWorld();
			}
			//*/
		}
		
		super.update();
	}
	
	protected function displayScores():void
	{
		removeAll();
		var tableCellEven:BitmapData = new BitmapData(FP.width,20,true,0x20000000);
		var tableCellOdd:BitmapData = new BitmapData(FP.width,20,true,0x10000000);
		
		// Add final score
		addGraphic(new Text("SCORE: " + Math.round(_score.getTotalScore()) + " [ "+_score.getTotalTime().toPrecision(2)+"s ]",0,0,{color:0x4D361F,size:24,align:"center",width:FP.width}));
		
		// Add table headers
		addGraphic(new Text("#",0,0,{width:32, align:"center", color:0}),0,0,i*20+24);
		addGraphic(new Text("MIX",32,0,{color:0, width:(FP.width - 32)/2}),0,0,i*20+24);
		addGraphic(new Text("SCORE",32+(FP.width - 32)/2,0,{color:0, width:(FP.width - 32)/2}),0,0,i*20+24);
		addGraphic(new Stamp(tableCellEven),2,0,i*20+24);
		
		// Iterate through our Score and output our statistics
		for (var i:uint = 0; i < C.COUNT_MIXES_PER_ROUND; i++)
		{
			// Add table content
			addGraphic(new Text(String(i+1),0,0,{width:32, align:"center", color:0x4D361F}),0,0,i*20+44);
			addGraphic(new Text(_mixList[i].getName(),32,0,{color:0x4D361F, width:(FP.width - 32)/2}),0,0,i*20+44);
			addGraphic(new Text(Math.round(_score.getValueOfMix("score",i)) + "\t[ " + _score.getValueOfMix("time",i).toPrecision(2) + "s ]",32+(FP.width - 32)/2,0,{color:0x4D361F, width:(FP.width - 32)/2}),0,0,i*20+44);
			
			// Add table background
			if (i % 2 == 1) addGraphic(new Stamp(tableCellEven),2,0,i*20+44);
			else addGraphic(new Stamp(tableCellOdd),2,0,i*20+44);
		}
	}
	
	public function addPourScore(score:Number, time:Number):void
	{
		_score.addPourScore(_mixesComplete, score, time);
		_scoreText.text = String(Math.round(_score.getTotalScore()));
	}
}
}