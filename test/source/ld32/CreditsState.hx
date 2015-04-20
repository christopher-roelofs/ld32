package ld32;

import flixel.FlxState;
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
using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author ...
 */
class CreditsState extends FlxState
{

	private var _txtTitle:FlxText;
	private var _txtDevs:FlxText;
	private var _txtContols:FlxText;
	private var _txtGameplay:FlxText;
	private var _txtControlsHeader:FlxText;
	private var _txtGameplayHeader:FlxText;
	private var _btnOptions:FlxButton;
	private var _btnPlay:FlxButton;
	private var _btnHints:FlxButton;
	private var _sndBeginPlay:FlxSound;
	
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
		_txtTitle = new FlxText(0, 20, 0, "Credits", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		_txtControlsHeader = new FlxText(0, 90, 0, "Art Assets:", 14);
		_txtControlsHeader.alignment = "center";
		_txtControlsHeader.screenCenter(true, false);
		add(_txtControlsHeader);
		
		_txtContols = new FlxText(0, 110, 0, "Sprites from the HaxeFlixel Tutorial", 10);
		_txtContols.alignment = "center";
		_txtContols.screenCenter(true, false);
		add(_txtContols);
		
		_txtGameplayHeader = new FlxText(0, 175, 0, "Sound Assets:", 14);
		_txtGameplayHeader.alignment = "center";
		_txtGameplayHeader.screenCenter(true, false);
		add(_txtGameplayHeader);
		
		_txtGameplay = new FlxText(0, 195, 0, "FreeSound.com creators klankbleed, glaneur-de-sons,\nddohler, j1987, qubodup, kolezan,\nsamulis, speedenza, kastenfrosch\nThanks!", 10);
		_txtGameplay.alignment = "center";
		_txtGameplay.screenCenter(true, false);
		add(_txtGameplay);
		
		
		_txtDevs = new FlxText(0, 300, 0, "Developed by Jared L. and Chris R. for Ludum Dare 32\n'Unconventional Weapon'", 10);
		_txtDevs.alignment = "center";
		_txtDevs.screenCenter(true, false);
		add(_txtDevs);
		
		_btnPlay = new FlxButton(0, 0, "Return", clickPlay);
		_btnPlay.x = (FlxG.width * 1/2) - (_btnPlay.width / 2);
		_btnPlay.y = FlxG.height - (_btnPlay.height + 10);
		_btnPlay.onUp.sound= FlxG.sound.load(AssetPaths.select__wav);
		add(_btnPlay);
	
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
		FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
			FlxG.switchState(new MenuState());
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