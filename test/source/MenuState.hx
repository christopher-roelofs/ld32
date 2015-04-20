package;

import flash.system.System;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import ld32.CreditsState;
using flixel.util.FlxSpriteUtil;


/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	private var _txtTitle:FlxText;
	private var _txtContols:FlxText;
	private var _txtGameplay:FlxText;
	private var _txtControlsHeader:FlxText;
	private var _txtGameplayHeader:FlxText;
	private var _btnOptions:FlxButton;
	private var _btnPlay:FlxButton;
	private var _btnHints:FlxButton;
	private var _sndBeginPlay:FlxSound;
	private var _btnCredits:FlxButton;
	#if desktop
	private var _btnExit:FlxButton;
	#end
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if (FlxG.sound.music == null) // don't restart the music if it's alredy playing
		{
			#if flash
			//FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__mp3, 1, true);
			#else
			//FlxG.sound.playMusic(AssetPaths.HaxeFlixel_Tutorial_Game__ogg, 1, true);
			#end
		}
		_sndBeginPlay = FlxG.sound.load(AssetPaths.begin__mp3);
		_txtTitle = new FlxText(0, 20, 0, "B r i m s t o n e", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		_txtControlsHeader = new FlxText(0, 90, 0, "Controls:", 14);
		_txtControlsHeader.alignment = "center";
		_txtControlsHeader.screenCenter(true, false);
		add(_txtControlsHeader);
		
		_txtContols = new FlxText(0, 110, 0, "Movement : W,A,S,D / Arrow Keys\nSelect Fireworks : 1-4\nLight Fuse: Space / F\nPress Space / F again to drop firework", 10);
		_txtContols.alignment = "center";
		_txtContols.screenCenter(true, false);
		add(_txtContols);
		
		_txtGameplayHeader = new FlxText(0, 175, 0, "Gameplay:", 14);
		_txtGameplayHeader.alignment = "center";
		_txtGameplayHeader.screenCenter(true, false);
		add(_txtGameplayHeader);
		
		_txtGameplay = new FlxText(0, 195, 0, "Crates contain what you need to survive\n\nUse the flame of your candle to light fireworks\nIf a demon assaults you, your candle will grow dimmer\n\nIf your candle goes out, you are defenseless...\n... and in the shadows, demons will reap your soul...\n\nBut if you find yourself in darkness, do not despair entirely!\nRe-light your candle with a match, and you may yet find the way out.", 10);
		_txtGameplay.alignment = "center";
		_txtGameplay.screenCenter(true, false);
		add(_txtGameplay);
		
		
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		_btnPlay.x = (FlxG.width * 1/4) - (_btnPlay.width / 2);
		_btnPlay.y = FlxG.height - (_btnPlay.height + 10);
		add(_btnPlay);
		
		_btnOptions = new FlxButton(0, 0, "Sound", clickOptions);
		_btnOptions.x = (FlxG.width * 2/4) - (_btnOptions.width / 2);
		_btnOptions.y = FlxG.height - (_btnOptions.height + 10);		
		_btnOptions.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(_btnOptions);
		
		_btnCredits = new FlxButton(0, 0, "Credits", clickCredits);
		_btnCredits.x = (FlxG.width * 3/4) - (_btnOptions.width / 2);
		_btnCredits.y = FlxG.height - (_btnOptions.height + 10);		
		_btnCredits.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(_btnCredits);
		
		

		#if desktop
		_btnExit = new FlxButton(FlxG.width - 28, 8, "X", clickExit);
		_btnExit.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(_btnExit);
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	#if desktop
	private function clickExit():Void
	{
		System.exit(0);
	}
	#end
	
	private function clickPlay():Void
	{
		_sndBeginPlay.play();
		_sndBeginPlay.fadeOut(4, 0);
		FlxG.camera.fade(FlxColor.BLACK,4, false, function() {
			FlxG.switchState(new PlayState());
		});
	}

	
	private function clickCredits():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
			FlxG.switchState(new CreditsState());
		});
	}
	
	private function clickOptions():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
			FlxG.switchState(new OptionsState());
		});
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
		_btnOptions = FlxDestroyUtil.destroy(_btnOptions);
		#if desktop
		_btnExit = FlxDestroyUtil.destroy(_btnExit);
		#end
	}
}