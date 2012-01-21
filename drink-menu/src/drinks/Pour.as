package drinks
{
[Bindable]
public class Pour extends Object
{
	public var id:String;
	
	public var name:String;
	
	public var viscosity:Number;
	
	public function get color():uint { return uint("0x"+decimalToHexString(_color,'000000')); }
	public function set color(value:uint):void { _color = Math.min(value, 0xffffff); }
	
	public function get alpha():uint { return uint("0x"+decimalToHexString(_alpha,'00')); }
	public function set alpha(value:uint):void { _alpha = Math.min(value, 0xff); }
	
	protected var _alpha:uint;
	protected var _color:uint;
	
	public function Pour(id:String, name:String, viscosity:Number, color:uint, alpha:uint)
	{
		this.id = id;
		this.name = name;
		this.viscosity = viscosity;
		_color = color;
		_alpha = alpha;
	}
	
	public static function decimalToHexString(value:int, mask:String):String
	{
		return String(mask + value.toString(16)).substr(-mask.length).toUpperCase();
	}
	
	public function toString():String
	{
		return name + "  0x" + decimalToHexString(_alpha,'00') + decimalToHexString(_color,'000000');
	}
}
}