package game
{
import drinks.Mix;
import drinks.Pour;

import net.flashpunk.FP;

public class Assets
{
	[Embed(source='../assets/drinks.xml', mimeType="application/octet-stream")]
	public static const XML_DRINKS:Class;
	
	public static var Pours:Array;
	public static var Mixes:Array;
	
	public static function CreatePourByID(id:String, targetVolume:Number, parent:Pour = null):Pour
	{
		trace("Creating a Pour...",id);
		var cp:Pour;
		var data:XMLList = FP.getXML(Assets.XML_DRINKS).pours[id];
		cp = new Pour(String(data.name), Number(data.viscosity), uint("0x"+data.color), uint("0x"+data.alpha+"000000"), targetVolume, parent);
		return cp;
	}
	
	public static function CreateMixByID(id:String):Mix
	{
		trace("Creating a Mix...",id);
		var m:Mix;
		var data:XMLList = FP.getXML(Assets.XML_DRINKS).mixes[id].pour;
		m = new Mix(FP.getXML(Assets.XML_DRINKS).mixes[id].name);
		for each (var o:XML in data)
		{
			m.addPour(String(o), Number(o.@shots))
		}
		m.commitMix();
		return m;
	}
	
	public static function GetPoursFromXML():void
	{
		var data:XMLList = FP.getXML(Assets.XML_DRINKS).pours.children();
		Assets.Pours = [];
		for each (var o:XML in data)
		{
			Assets.Pours.push(o.name());
		}
	}
	
	public static function GetMixesFromXML():void
	{
		var data:XMLList = FP.getXML(Assets.XML_DRINKS).mixes.children();
		Assets.Mixes = [];
		for each (var o:XML in data)
		{
			Assets.Mixes.push(o.name());
		}
	}
}
}