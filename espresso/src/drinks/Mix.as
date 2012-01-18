package drinks
{
	import flash.display.BitmapData;
	
	import game.Assets;
	import game.V;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;

	public class Mix
	{
		protected var _pours:Vector.<String>;
		protected var _parts:Vector.<Number>;
		protected var _currentShotTarget:Number;
		protected var _shotSize:Number;
		protected var _name:String;
		protected var _isCommitted:Boolean;
		
		public function Mix(name:String, shotSize:Number = 50)
		{
			_name = name;
			_pours = new <String>[];
			_parts = new <Number>[];
			_currentShotTarget = FP.height;
			_shotSize = shotSize;
			_isCommitted = false;
		}
		
		public function addPour(id:String, shots:Number):void
		{
			_pours.push(id);
			_parts.push(shots);
		}
		
		public function getRemainingPours():uint
		{
			return _pours.length;
		}
		
		public function createMixGuides(currentWorld:World):void
		{
			var i:int;
			var lastHeight:uint = FP.height;
			// If our Mix is committed, we want to iterate backward through the list.
			if (_isCommitted)
			{
				for (i = _parts.length - 1; i >= 0; i--)
				{
					currentWorld.addGraphic(new Stamp(new BitmapData(FP.width,3,true,0xaa000000)),1,0,lastHeight - _parts[i] * _shotSize - 1);
					lastHeight -= _parts[i] * _shotSize;
				}
			}
			
			// Otherwise, we want to iterate forward through the list.
			else
			{
				for (i = 0; i < _parts.length; i++)
				{
					currentWorld.addGraphic(new Stamp(new BitmapData(FP.width,3,true,0xaa000000)),1,0,lastHeight - _parts[i] * _shotSize - 1);
					lastHeight -= _parts[i] * _shotSize;
				}
			}
			
			var nameText:Text = new Text(_name,0,0,{color:0x4D361F, size:24});
			currentWorld.addGraphic(nameText,0,FP.width/2 - nameText.width/2, 8);

		}
		
		public function commitMix():void
		{
			if (!_isCommitted)
			{
				_pours.reverse();
				_parts.reverse();
				_isCommitted = true;
			}
		}
		
		public function getNextPour():Pour
		{
			var p:Pour;
			
			if(_pours.length > 0)
			{
				_currentShotTarget -= _parts.pop() * _shotSize;
				p = Assets.CreatePourByID(_pours.pop(),_currentShotTarget, V.ActivePour);
			}
			else
			{
				p = null;
			}
			return p;
		}
	}
}