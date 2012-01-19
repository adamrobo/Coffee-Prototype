package drinks
{
import flash.display.BitmapData;

import game.C;
import game.V;

import net.flashpunk.Entity;
import net.flashpunk.FP;
import net.flashpunk.graphics.Graphiclist;
import net.flashpunk.graphics.Image;
import net.flashpunk.graphics.Text;

import worlds.CoffeeWorld;

/**
 * Pour.as
 * An entity that displays and maintains a single pour of liquid. 
 * @author Zachary Weston Lewis
 */
public class Pour extends Entity
{
	protected var _volume:Number;
	protected var _targetVolume:Number;
	protected var _viscosity:Number;
	protected var _fillVelocity:Number;
	protected var _time:Number;
	
	protected var _image:Image;
	
	protected var _alpha:uint;
	protected var _color:uint;
	
	protected var _parent:Pour;
	
	protected var _name:String;
	
	protected var _isActive:Boolean;
	protected var _isPouring:Boolean;
	protected var _isLocked:Boolean;
	
	protected var _id:uint;
	
	public function Pour(name:String, viscosity:Number, color:uint, alpha:uint, targetVolume:Number, parent:Pour = null)
	{
		// For a good pour, we'll want to know:
		// 1. What is the name of the drink we're pouring?
		// 2. What are the drink's physical properties?
		// 3. What are the drink's visual properties?
		// 4. How much of it do we need?
		// 5. What is it on top of?
		// 6. What is the current state of the pour?
		
		// 1. What is the name of the drink we're pouring?
		_name = name;
		
		// 2. What are the drink's physical properties?
		_viscosity = viscosity;
		_fillVelocity = 0;
		
		// 3. What are the drink's visual properties?
		_color = color;
		_alpha = alpha;
		var drawColor:uint = _color + _alpha;
		
		_image = new Image(new BitmapData(FP.width, FP.height, true, drawColor));
		_image.y = 0;
		
		// 4. How much of it do we need?
		_volume = 0;
		_targetVolume = targetVolume;
		
		super(x, y, _image);
		
		// 5. What is it on top of?
		_parent = parent;
		updateGraphic();
		
		// 6. What is the current state of the pour?
		_isPouring = false;
		_isActive = false;
		_isLocked = false;
		
		_time = 0;
		
	}
	
	/**
	 * Get the current value of the surface of the pour. 
	 * @return The current value of the surface of the pour.
	 */		
	public function getSurfaceValue():Number
	{
		return y - _volume;
	}
	
	protected function updateGraphic():void
	{
		// We need to perform the following actions:
		// 1. Update the position of the bottom of the volume.
		// 2. Update the height of the volume.
		
		// 1. Update the position of the bottom of the volume.
		if (_parent != null)
		{
			y = Math.round(_parent.getSurfaceValue());
		}
		else
		{
			y = FP.height;
		}
		
		// 2. Update the height of the volume.
		
		// We're going to recreate the height and lock it so there's no overlap on these volumes.
		var newHeight:uint = Math.round(_volume);
		if (newHeight == 0)
		{
			_image.visible = false;
		}
		else
		{
			_image = new Image(new BitmapData(FP.width, newHeight, true, _alpha + _color));
			_image.y = -_image.height;
			graphic = _image;
		}
	}
	
	/**
	 * Sets the Pour's status to active or not.
	 * @param isActive true to activate the Pour, false to deactivate the Pour
	 * 
	 */
	public function setActive(isActive:Boolean):void
	{
		_isActive = isActive;
	}
	
	/**
	 * Alerts the Pour that the user has begun pouring,
	 * and that it should increase its volume. 
	 */
	public function beginPour():void
	{
		_isPouring = true;
	}
	
	/**
	 * Alerts the Pour that the user has stopped pouring,
	 * and that is thould stop increasing its volume.
	 */
	public function endPour():void
	{
		_isPouring = false;
	}
	
	/**
	 * Alerts the Pour that it is completely done filling,
	 * and to score and lock the Pour.
	 */
	public function scorePour():void
	{
		// Upon scoring, prevent any further movement of the pour.
		_isLocked = true;
		
		// Calculate the delta between the current volume and the maximum.
		var delta:Number = Math.abs(getSurfaceValue() - _targetVolume);
		
		// Determine our score based on our delta.
		var score:Text = new Text("Score: "+Math.round(delta),0,0,{color:0xff0000});
		score.x = 4;
		score.y = getSurfaceValue() - y;
		graphic = new Graphiclist(_image, score);
		
		// If our current world exists and is a CoffeeWorld, send our new score.
		var w:CoffeeWorld = CoffeeWorld(world);
		if(w != null) w.addPourScore(delta, _time);
	}
	
	/**
	 * Get the lock status of the Pour.
	 * If a pour is locked, it doesn't update it's height or graphic.
	 * @return true if the Pour is locked, false if the Pour is unlocked
	 */
	public function getIsLocked():Boolean
	{
		return _isLocked;
	}
	
	public override function update():void
	{
		// If the Pour is unlocked, we want to apply physics.
		if(!_isLocked)
		{
			// If this is the current Pour and we have started pouring,
			// we want to increase the velocity we fill by our filling
			// acceleration.
			if (_isActive && _isPouring)
			{
				_fillVelocity += C.A_FILL * FP.elapsed;
				
			}
				
				// If we aren't currently pouring or aren't active, we still
				// want to update our Pour, we just want to slow it down.
			else
			{
				_fillVelocity -= _fillVelocity * C.DAMPING_FILL;
			}
			
			// We don't want our velocity to exceed our maximum velocity.
			_fillVelocity = Math.min(_fillVelocity, C.V_MAX_FILL);
			
			// Once we know our velocity this tick, let's increase the Pour's volume.
			_volume += _fillVelocity * FP.elapsed;
			
			// We also want to keep track of the time this Pour has been alive,
			// for future scoring purposes.
			_time += FP.elapsed;
			
			// Update our Pour's graphic based on the new volume.
			updateGraphic();
			
			// If the Pour isn't active, our parent is locked, and our
			// current filling velocity is very small, we want to score
			// our fill and lock it to prevent it from updating its
			// graphics and physics.
			if (!_isActive && (_parent == null || _parent.getIsLocked()) && _fillVelocity < C.V_FILL_CLAMP)
			{
				_fillVelocity = 0;
				scorePour();
				
			}
		}
	}
}
}