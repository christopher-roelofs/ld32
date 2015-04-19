package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;
using flixel.util.FlxSpriteUtil;

class HintsState extends FlxState
{
	// define our screen elements
	private var _txtTitle:FlxText;
	private var _txtHints:FlxText;
	private var _btnBack:FlxButton;
	#if desktop
	private var _btnFullScreen:FlxButton;
	#end
	
	override public function create():Void 
	{
		// setup and add our objects to the screen
		_txtTitle = new FlxText(0, 20, 0, "Hints", 22);
		_txtTitle.alignment = "center";
		_txtTitle.screenCenter(true, false);
		add(_txtTitle);
		
		_txtHints = new FlxText(0, 60, 0, "# Look for crates\n# Don't let your candle go out \n# Find an exit\n # Not all fireworks work the same", 22);
		_txtHints.alignment = "center";
		_txtHints.screenCenter(true, false);
		add(_txtHints);
		
		
		#if desktop
		_btnFullScreen = new FlxButton(0, _barVolume.y + _barVolume.height + 8, FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED", clickFullscreen);
		_btnFullScreen.screenCenter(true, false);
		add(_btnFullScreen);
		#end
		
		
		_btnBack = new FlxButton((FlxG.width/2) - 20, FlxG.height-28, "Back", clickBack);
		_btnBack.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(_btnBack);
		
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	#if desktop
	private function clickFullscreen():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		_btnFullScreen.text = FlxG.fullscreen ? "FULLSCREEN" : "WINDOWED";
		_save.data.fullscreen = FlxG.fullscreen;
	}
	#end
	
	/**
	 * The user clicked the back button - close our save object, and go back to the MenuState
	 */
	private function clickBack():Void
	{
		FlxG.camera.fade(FlxColor.BLACK,.33, false,function() {
			FlxG.switchState(new MenuState());
		});
	}
	
	
	override public function destroy():Void 
	{
		super.destroy();
		
		// cleanup all our objects!
		_txtTitle = FlxDestroyUtil.destroy(_txtTitle);
		_btnBack = FlxDestroyUtil.destroy(_btnBack);
		#if desktop
		_btnFullScreen = FlxDestroyUtil.destroy(_btnFullScreen);
		#end
	}
}