package
{
	import Player;
	
	import net.flashpunk.World;
	
	public class GameWorld extends World
	{
		public var _player : Player;
		public var _fillLine : FillLine;
		
		public function GameWorld()
		{
			super();
		}
		
		public override function begin():void
		{
			_player = new Player();
			add(_player);
			_fillLine = new FillLine();
			add(_fillLine);
		}
	}
}