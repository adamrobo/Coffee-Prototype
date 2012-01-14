package net.thegamestudio.waveforms
{
	public class Wave extends Object
	{
		/** Amplitude */
		public var a:Number;
		/** Wavenumber */
		public var k:Number;
		/** Angular Frequency */
		public var w:Number;
		/** Phase */
		public var phi:Number;
		/** Is this wave represented as a sinc wave? */
		public var isSinc:Boolean;
		
		/** The center of the sinc */
		public var sCenter:Number;
		
		public function Wave(a:Number, k:Number, w:Number, phi:Number, isSinc:Boolean = false)
		{
			this.a = a;
			this.k = k;
			this.w = w;
			this.phi = phi;
			this.isSinc = isSinc;
		}
		
		public function evaluate(x:Number, t:Number):Number
		{
			if(isSinc)
			{
				return a * Math.sin(k * (x - sCenter) - w * t + phi) / (x - sCenter);
			}
			
			return a * Math.sin(k * x - w * t + phi);
		}
	}
}