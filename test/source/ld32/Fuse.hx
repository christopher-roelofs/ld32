package ld32;

import flixel.effects.FlxSpriteFilter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter.Bounds;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxDestroyUtil;
import openfl.filters.GlowFilter;
import flixel.system.FlxSound;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Fuse extends FlxEmitterExt
{
	private var _whitePixel:FlxParticle;
	private var _glowFilter:GlowFilter;
	private var _pixelFilter:FlxSpriteFilter;
	private var _sndFuse:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=10) 
	{
		Size = 10;
		super(X, Y, Size);
		rotation = new Bounds<Float>(0, 0);
		setMotion(0, 100, 0.25, 360, 0, 0);
		setAlpha(1, 1, 0, 0);
		var sligthlyYellow = FlxColorUtil.makeFromARGB(1, 255, 255, 200);
		
		
		
		_glowFilter = new GlowFilter(0xFFFFAA,0.25,4,4,10,1,false,false);
		
		_sndFuse = FlxG.sound.load(AssetPaths.fuse__wav);
		
		
		for (i in 0...(Std.int(maxSize))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
			_whitePixel.visible = true; 
			_pixelFilter = new FlxSpriteFilter(_whitePixel, 8, 8);
			_pixelFilter.addFilter(_glowFilter, true);
			add(_whitePixel);
			
		}		
		
		
	}
	
	public function stopSound():Void {
		_sndFuse.stop();
	}
	
	public function init():Void
	{
		super.start(false, .25, 0.01);
		_sndFuse.play();

	}
	
	public override function destroy():Void
	{
		_whitePixel = FlxDestroyUtil.destroy(_whitePixel);
		_sndFuse = FlxDestroyUtil.destroy(_sndFuse);
		_pixelFilter.destroy();
	}
	
	
}