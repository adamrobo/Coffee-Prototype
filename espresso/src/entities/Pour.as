package entities
{
	import flash.display.BitmapData;
	
	import game.C;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
		
	/**
	 * CoffeePour.as
	 * An entity that displays a single pour of liquid. 
	 * @author Zachary Weston Lewis
	 */
	public class Pour extends Entity
	{
		protected var _volume:Number;
		protected var _targetVolume:Number;
		protected var _viscosity:Number;
		protected var _alpha:Number;
		
		protected var _fillVelocity:Number;
		
		protected var _image:Image;
		
		protected var _color:uint;
		
		protected var _parent:Pour;
		
		protected var _name:String;
		
		protected var _isActive:Boolean;
		protected var _isPouring:Boolean;
		
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
			//y = (_parent != null) ? _parent.getSurfaceValue() : FP.height;
			updateGraphic();
			
			// 6. What is the current state of the pour?
			_isPouring = false;
			_isActive = false;
			
			
		}
		
		/**
		 * Get the current value of the surface of the pour. 
		 * @return The current value of the surface of the pour.
		 */		
		public function getSurfaceValue():Number
		{
			return y - _volume;
		}
		
		public function updateGraphic():void
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
			
			// Two different ways.
			// Scaling (faster)
			_image.scaleY = _volume / FP.height;
			_image.y = -_image.scaledHeight;
		}
		
		public function setActive(isActive:Boolean):void
		{
			_isActive = isActive;
		}
		
		public function beginPour():void
		{
			_isPouring = true;
			trace("Pouring began.");
		}
		
		public function endPour():void
		{
			_isPouring = false;
			trace("Pouring ended.");
		}
		
		public function scorePour():void
		{
			
		}
		
		public override function update():void
		{
			if (_isActive && _isPouring)
			{
				_fillVelocity += C.A_FILL * FP.elapsed;
			}
			else
			{
				_fillVelocity -= _fillVelocity * C.DAMPING_FILL;
			}
			
			_volume += _fillVelocity * FP.elapsed; 
			
			updateGraphic();
		}
	}
}