package drinks
{
public class Pour extends Object
{
	[Bindable]
	public var name:String;
	
	[Bindable]
	public function get color():uint
	{
		return uint("0x"+fixedInt(_color,'000000'));
	}
	
	public function set color(value:uint):void
	{
		_color = value;
	}
	
	protected var _color:uint;
	
	public function Pour(name:String, color:uint)
	{
		this.name = name;
		_color = color;
	}
	
	private function fixedInt(value:int, mask:String):String
	{
		return String(mask + value.toString(16)).substr(-mask.length).toUpperCase();
	}
	
	public function toString():String
	{
		return name + "  0x" + fixedInt(_color,'000000');
	}
}
}