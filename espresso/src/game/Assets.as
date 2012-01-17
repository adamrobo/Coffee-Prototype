package game
{
	import entities.Pour;
	
	import net.flashpunk.FP;

	public class Assets
	{
		[Embed(source='../assets/drinks.xml', mimeType="application/octet-stream")]
		public static const XML_DRINKS:Class
		public static const DRINKS:Array = ["espresso","wholeMilk","skimMilk"];
		public static function CreatePourByID(id:String, targetVolume:Number, parent:Pour = null):Pour
		{
			var cp:Pour;
			var data:XMLList = FP.getXML(Assets.XML_DRINKS)[id];
			cp = new Pour(String(data.name), Number(data.viscosity), uint("0x"+data.color), uint("0x"+data.alpha+"000000"), targetVolume, parent);
			return cp;
		}
	}
}