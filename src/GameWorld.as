package
{
	import Player;
	
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	public class GameWorld extends World
	{
		public var _player : Player;
		public var _fillLine : FillLine;
		protected var _scoreText : Text;
		
		public function GameWorld()
		{
			super();
		}
		
		override public function begin():void
		{
			_player = new Player();
			add(_player);
			_fillLine = new FillLine();
			add(_fillLine);
			
			_scoreText = new Text( "0", 100, 10, 200 );
			addGraphic( _scoreText );
		}
		
		override public function update():void
		{
			super.update();
			_scoreText.text = _player.scoreGrade;
			_fillLine.y = _player.fillLineYPosition; // set fill line to new position
		}
		
	}
}