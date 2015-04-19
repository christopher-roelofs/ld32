package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Exit extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.BLACK);
	}
	
	override public function kill():Void 
	{
		alive = false;
		exists = false;
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}