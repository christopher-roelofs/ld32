package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Container extends FlxSprite
{
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.container__png, false, 16, 16);
	}
	
	override public function kill():Void 
	{
		alive = false;
		exists = false;
		//FlxTween.tween(this, { alpha:0, y:y - 16 }, .66, {ease:FlxEase.circOut, complete:finishKill } );
	}
	
	private function finishKill(_):Void
	{
		exists = false;
	}
}