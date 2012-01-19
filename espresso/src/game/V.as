package game
{
import drinks.Pour;

public class V
{
	public static var ActivePour:Pour;
	
	public static function SetActivePour(p:Pour):void
	{
		if (V.ActivePour != null) V.ActivePour.setActive(false);
		V.ActivePour = p;
		if (V.ActivePour != null) V.ActivePour.setActive(true);
	}
	
	public static var pourCount:uint;
}
}