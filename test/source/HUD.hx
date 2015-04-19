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
	private var _txtMoney:FlxText;
	private var _sprHealth:FlxSprite;
	private var _sprMoney:FlxSprite;
	private var _firework1:FlxText;
	private var _firework2:FlxText;
	private var _firework3:FlxText; 
	private var _firework4:FlxText;
	
	public function new() 
	{
		super();
		_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		
		_firework1 = new FlxText(60, 2, 0, "Firework1 x 0", 8);
		_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		
		_firework2 = new FlxText(180, 2, 0, "Firework2 x 0", 8);
		_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		
		_firework3 = new FlxText(300, 2, 0, "Firework3 x 0", 8);
		_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		
		_firework4 = new FlxText(420, 2, 0, "Firework4 x 0", 8);
		_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		add(_sprBack);
		add(_firework1);
		add(_firework2);
		add(_firework3);
		add(_firework4);
		
		
		forEach(function(spr:FlxSprite) {
			spr.scrollFactor.set();
		});
	}
	
	public function updateHUD(Health:Int = 0, Money:Int = 0):Void
	{
		_txtHealth.text = Std.string(Health) + " / 3";
		_txtMoney.text = Std.string(Money);
		_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		
	}
	
	public function updateFwHUD(fw1:Int = 0, fw2:Int = 0,fw3:Int = 0,fw4:Int = 0):Void
	{
		_firework1.text = "Firework1 x " + Std.string(fw1);
		_firework2.text = "Firework2 x " + Std.string(fw2);
		_firework3.text = "Firework3 x " + Std.string(fw3); 
		_firework4.text = "Firework4 x " + Std.string(fw4);
		
	}
	
	public function toggleFw(fw:Int=0):Void
	{
		if (fw == 1)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 2)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 3)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
		}
		else if (fw == 4)
		{
			_firework1.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework2.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework3.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1, 1);
			_firework4.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.RED, 1, 1);
		}
	}
}