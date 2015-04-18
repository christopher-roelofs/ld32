package ld32;

import flixel.addons.effects.FlxWaveSprite;
import flixel.effects.FlxSpriteFilter;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import openfl.filters.GlowFilter;
import flixel.util.FlxRandom;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flixel.FlxG;


/**
 * ...
 * @author ...
 */
class Candle extends FlxTypedGroup<FlxSprite>
{

	private var _lumosityLevel:Int;
	private var _candleGraphic:FlxSprite;
	private var _waveOverlayGraphic:FlxSprite;
	private var _waveOverlay:FlxWaveSprite;
	private var _pixelFilter:FlxSpriteFilter;
	private var _glowFilter:GlowFilter;
	
	public function new() 
	{
		super();	
		_lumosityLevel = 3;
		
		var color = FlxColorUtil.makeFromARGB(0.75, 255, 255, 100);
		
		_candleGraphic = new FlxSprite().makeGraphic(2, 2, color, false);
		add(_candleGraphic);
		

		
		_pixelFilter = new FlxSpriteFilter(_candleGraphic, 8, 8);
		_glowFilter = new GlowFilter(0xFFFFAA,0.25,8,8,30,1,false,false);
		_pixelFilter.addFilter(_glowFilter);
		
		
		_waveOverlay = new FlxWaveSprite(_candleGraphic, WaveMode.ALL, 4, -1, 4);
		add(_waveOverlay);
		
	}
	
	public function updatePosition(x, y) {
		_candleGraphic.setPosition(x, y);
		_waveOverlay.setPosition(x, y);
	}
	
	public function setLumosityLevel(x:Int) 
	{
		_glowFilter.strength = 10 * x;
		_pixelFilter.applyFilters();
	}
	
		public override function update() {	
		super.update();
	}
}