package game
{
/**
 * Score.as
 * An object that handles scoring functionality and updating for a single game.
 * @author Zachary Weston Lewis
 */
public class Score
{
	protected var _mixes:Vector.<Vector.<Object>>;
	protected var _currentScore:Number;
	protected var _currentTime:Number;
	
	public function Score()
	{
		_mixes = new <Vector.<Object>>[];
		_currentScore = 0;
		_currentTime = 0;
	}
	
	/**
	 * Adds the score of a completed Pour to the current Score.
	 * @param mixIndex The index of the Mix to add the score to.
	 * @param score The numeric score value of the Pour
	 * @param time The total time spent on the pour
	 */
	public function addPourScore(mixIndex:uint, score:Number, time:Number):void
	{
		// If we're trying to add a score to a mix out of our Vector, add them
		// until we're in bounds.
		while(mixIndex >= _mixes.length) _mixes.push(new <Object>[]);
		
		// Create a new object and add it to our current mix score.
		var pourScore:Object = {score:score, time:time};
		_mixes[mixIndex].push(pourScore);
		
		// Also update our current score
		_currentScore += score;
		_currentTime += time;
	}
	
	/** @return The current score of the game */
	public function getTotalScore():Number { return _currentScore; }
	
	/** @return The current time of the game */
	public function getTotalTime():Number { return _currentTime;}
	
	/** @return The number of mixes with recorded scores. */
	public function getNumberOfMixes():uint { return _mixes.length; }
	
	public function getValueOfMix(value:String, mixIndex:uint):Number
	{
		var mixValue:Number = 0;
		
		if (mixIndex < _mixes.length)
		{
			for each(var o:Object in _mixes[mixIndex])
			{
				mixValue += Number(o[value]);
			}
		}
		
		return mixValue;
	}
}
}