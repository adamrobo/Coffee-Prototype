package
{
	import flash.display.BitmapData;

	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class FillLine extends Entity
	{
		public var fillLineImage:Image;
		
		public function FillLine(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			fillLineImage = new Image(new BitmapData(240, 1));
			fillLineImage.color = 0xFFFFFF;
			graphic = fillLineImage;
			setHitbox(240,1);
			
			y = 100;
			
			type="Line"

			
			super(x, y, graphic, mask);
		}
	}
}