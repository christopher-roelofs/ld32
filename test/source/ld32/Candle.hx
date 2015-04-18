package ld32;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import openfl.filters.GlowFilter;
import flixel.util.FlxRandom;


/**
 * ...
 * @author ...
 */
class Candle extends FlxSprite
{

	private var _lumosityLevel:Int;
	private var _pixelFilter:FlxSpriteFilter;
	private var _glowFilter:GlowFilter;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y);	
		_lumosityLevel = 3;
		
		var color = FlxColorUtil.makeFromARGB(0.75, 255, 255, 100);
		
		makeGraphic(2, 2, color, false);
		
		_pixelFilter = new FlxSpriteFilter(this, 8, 8);
		_glowFilter = new GlowFilter(0xFFFFAA,0.25,8,8,30,1,false,false);
		_pixelFilter.addFilter(_glowFilter);
		

		
	}
	
	public function setLumosityLevel(x:Int) 
	{
		_glowFilter.strength = 10 * x;
		_pixelFilter.applyFilters();
	}
	
	public override function update() {
	}
	
}