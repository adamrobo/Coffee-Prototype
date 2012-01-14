package net.thegamestudio.waveforms
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.effects.Tween;
	import mx.effects.TweenEffect;
	
	import spark.effects.easing.EaseInOutBase;
	
	public class WaveformDisplay extends MovieClip
	{
		[Bindable]
		public var waves:ArrayCollection;
		
		protected var areaHeight:uint;
		protected var areaWidth:uint;
		
		protected var graphArea:Sprite;
		
		protected var doSinc:Boolean;
		protected var sincEffect:Number = 0;
		protected const SINC_RATE:Number = 0.001;

		public function WaveformDisplay(x:int, y:int, width:uint, height:uint)
		{
			this.x = x;
			this.y = y;
			this.graphics.beginFill(0xdddddd);
			this.graphics.drawRect(0,0,width,height);
			areaWidth = width;
			areaHeight = height;
			graphArea = new Sprite();
			addChild(graphArea);
			waves = new ArrayCollection();
			waves.addItem(new Wave(1000,0.05,0,0,true));
			addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			doSinc = false;
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			super();
		}
		
		public function addWaveform(a:Number, k:Number, w:Number, phi:Number):void
		{
			// u(x,t) = a(x,t) * sin(k * x - w * t + phi)
			// u(x,t) = A(x - vg * t) * sin(k * x - w * t + phi)
			waves.addItem(new Wave(a, k, w, phi));
		}
		
		public function drawWaveforms(t:Number = 0, steps:Number = 100):void
		{
			var stepSize:Number = steps;
			var current:Number;
			graphArea.graphics.clear();
			graphArea.graphics.lineStyle(1, 0xffffffff);
			graphArea.graphics.beginFill(0xffffff);
			var wa:Wave = waves[0];
			if(waves[1])
			{
				graphics.moveTo(-1,0);
				for(var i:Number = 0; i < areaWidth+30; i+= stepSize)
				{
					current = 0;
					for(var j:uint = 1; j < waves.length; j++)
					{
						wa = Wave(waves[j]);
						current += wa.evaluate(i,t); 
					}
					if(doSinc)
					{
						sincEffect += SINC_RATE;
						if(sincEffect > 1) sincEffect = 1;
						
					}
					else
					{
						sincEffect -= SINC_RATE;
						if(sincEffect < 0) sincEffect = 0;
					}
					var e:Number = waves[0].evaluate(i,0);
					current += sincEffect * e;
					
					graphArea.graphics.lineTo(i,current);
				}
			}
			graphArea.graphics.lineTo(i,areaHeight/2);
			graphArea.graphics.lineTo(-1,areaHeight/2);
			graphArea.y = areaHeight / 2;
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			Wave(waves[0]).sCenter = e.localX;
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			doSinc = true;
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			doSinc = false;
		}
		
		
	}
}