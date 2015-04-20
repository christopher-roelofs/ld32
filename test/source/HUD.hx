package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _sprBack:FlxSprite;
	private var _txtHealth:FlxText;	
	private var _sprHealth:FlxSprite;	
	private var _firework1:FlxText;
	private var _firework2:FlxText;
	private var _firework3:FlxText; 
	private var _firework4:FlxText;
	
	public function new() 
	{
		super();
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		
		_firework1 = new FlxText(90, 2, 0, "Cherosiphon x 0", 8);
		_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_firework1.alpha = getNewAlpha(0);
		_firework2 = new FlxText(205, 2, 0, "Sulti Bomb x 0", 8);
		_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_firework2.alpha = getNewAlpha(0);
		_firework3 = new FlxText(320, 2, 0, "Bang Fai x 0", 8);
		_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_firework3.alpha = getNewAlpha(0);
		_firework4 = new FlxText(440, 2, 0, "Dahlia x 0", 8);
		_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		_firework4.alpha = getNewAlpha(0);
		add(_sprBack);
		add(_firework1);
		add(_firework2);
		add(_firework3);
		add(_firework4);
		
		_txtHealth = new FlxText(0, 2, 0, "Matches x 0", 8);
		_txtHealth.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.BLUE, 1, 1);
		_txtHealth.alpha = getNewAlpha(0);
		add(_txtHealth);
		
		forEach(function(spr:FlxSprite) {
			spr.scrollFactor.set();
		});
	}
	
	public function updateHUD(matches:Int):Void
	{
		_txtHealth.text = "Matches x " + Std.string(matches);
		_txtHealth.alpha = getNewAlpha(matches);
	}
	
	
	private function getNewAlpha(count:Int):Float {
		//var newAlpha = 0.25 + 0.25 * count;
		//return (newAlpha > 1) ? 1 : newAlpha;
		return 1;
		
	}
	
	public function updateFwHUD(fireworks:Array<Int>, selected:Int=-1):Void
	{
		_firework1.text = "Cherosiphon x " + Std.string(fireworks[0]);
		_firework2.text = "Sulti Bomb x " + Std.string(fireworks[1]);
		_firework3.text = "Bang Fai x " + Std.string(fireworks[2]); 
		_firework4.text = "Dahlia x " + Std.string(fireworks[3]);
		//_firework1.alpha = getNewAlpha(fw1);
		//_firework2.alpha = getNewAlpha(fw2);
		//_firework3.alpha = getNewAlpha(fw3);
		//_firework4.alpha = getNewAlpha(fw4);		
		toggleFw(selected);		
		
	}
	
	public function toggleFw(fw:Int=-1):Void
	{
		if (fw == 0)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 1)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 2)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 3)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
		}
	}
}