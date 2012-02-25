package game
{
import worlds.CoffeeWorld;

public class C
{
	public static const ENTRY:Class = CoffeeWorld;
	
	// Physics
	public static const A_FILL:Number = 325;
	public static const V_MAX_FILL:Number = 1050;
	public static const DAMPING_FILL:Number = 0.08;
	public static const V_FILL_CLAMP:Number = 0.2;
	
	// Gameplay
	public static const SCORE_NAMES:Vector.<String> = new <String>["Perfect","Great","OK","Poor","Terrible"];
	public static const SCORE_VALUES:Vector.<Number> = new <Number>[3,10,20,40,Number.POSITIVE_INFINITY];
	public static const COUNT_MIXES_PER_ROUND:uint = 20;
	
	
}
}