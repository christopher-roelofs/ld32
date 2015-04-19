package ld32;

import flixel.effects.FlxSpriteFilter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter.Bounds;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxDestroyUtil;
import openfl.filters.GlowFilter;

/**
 * ...
 * @author ...
 */
class SparklerExplosion extends Explosion
{
	
	private var _whitePixel:FlxParticle;
	private var _glowFilter:GlowFilter;
	private var _pixelFilter:FlxSpriteFilter;
	

	public function new(X:Float=0, Y:Float=0, Size:Int=20) 
	{	
		Size = 20;
		super(X, Y, Size);
		setAlpha(1, 1, 0, 0);
		rotation = new Bounds<Float>(0, 0);
		setMotion(0, 100, 0.25, 360, 0, 0);
		
		var sligthlyYellow = FlxColorUtil.makeFromARGB(1, 255, 255, 200);	
		
		_glowFilter = new GlowFilter(0xFFFFAA,0.25,16,16,10,1,false,false);
	
		for (i in 0...(Std.int(maxSize))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(4, 4, FlxColor.WHITE);
			_whitePixel.visible = true; 
			_pixelFilter = new FlxSpriteFilter(_whitePixel, 10, 10);
			_pixelFilter.addFilter(_glowFilter, true);
			add(_whitePixel);
			
		}		
		//collides = false;
	
	}
	public override function activate():Void {
		super.activate();				
		super.start(false, .25, 0.01);
	}
	
	public override function duration():Float {
		return 4;
	}

	public override function destroy():Void
	{
		_whitePixel = FlxDestroyUtil.destroy(_whitePixel);
		_pixelFilter.destroy();
	}
	
	public override function update():Void
	{
		super.update();
	}
	
}