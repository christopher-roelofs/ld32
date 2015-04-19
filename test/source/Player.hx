package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import haxe.Log;
import ld32.BottleRocket;
import ld32.Candle;
import ld32.Firework;
import ld32.Sparkler;

class Player extends FlxSprite
{
	public var speed:Float = 200;
	private var _sndStep:FlxSound;
	
	private var _lumosity:Int;
	private var _fw1:Int = 0;
	private var _fw2:Int = 0;
	private var _fw3:Int = 0;
	private var _fw4:Int = 0;
	private var _candle:Candle;
	private var _sparklerTimer:FlxTimer;
	private var _holdingFirework:Firework;
	public var currentFireworkType:Int;
	private var _playState:PlayState;
	
	public function addToPlayState(playState:PlayState) {
		_playState = playState;
		_playState.add(this);
		_playState.add(_candle);
		updateLumosityForHealth();
	}
	
	public function setHealth(newHealthValue:Int) {
		health = newHealthValue;
		updateLumosityForHealth();
	}
	
	public function addHealth(hp:Int) {
		health += hp;
		updateLumosityForHealth();
	}

	private function updateLumosityForHealth() {
		_playState.setLumosity(0.5 + (health / 6.0));
	}
	
	public function updateFwInventory(fw:Int)
	{
		if (fw == 1)
		{
			_fw1 ++;
			
		}
		else if (fw == 2)
		{
			_fw2 ++;
		}
		else if (fw == 3)
		{
			_fw3 ++;
		}
		else
		{
			_fw4 ++;
		}
		
		_playState._hud.updateFwHUD(_fw1, _fw2, _fw3, _fw4);
		
		
	}
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		

		
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		drag.x = drag.y = 1600;
		setSize(8, 14);
		offset.set(4, 2);
		
		_sndStep = FlxG.sound.load(AssetPaths.step__wav);
		
		health = 3;
		
		_candle = new Candle();
		
		currentFireworkType = 0;
		
	}
	
	public function setCurrentFireworkType(fireworkType:Int):Void {
		currentFireworkType = fireworkType;
		_playState._hud.toggleFw(fireworkType);
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		var _togglefw1 = false;
		
		var useItem = false;
		
		var changedFireworkType = 0;
		
		#if !FLX_NO_KEYBOARD
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		changedFireworkType = (FlxG.keys.anyJustPressed(["ONE"])) ? 1 : changedFireworkType;				
		changedFireworkType = (FlxG.keys.anyJustPressed(["TWO"])) ? 2 : changedFireworkType;		
		changedFireworkType = (FlxG.keys.anyJustPressed(["THREE"])) ? 3 : changedFireworkType;		
		changedFireworkType = (FlxG.keys.anyJustPressed(["FOUR"])) ? 4 : changedFireworkType;		
		useItem = FlxG.keys.anyJustPressed(["SPACE"]);	
		#end
		#if mobile
		_up = _up || PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		_down = _down || PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		_left  = _left || PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_right = _right || PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		#end
		
		/*
				if (useItem && !_sparkler.on) {						
			_sparkler.on = true;
			_sparkler.visible = true;
			_sparklerTimer.start(5, stopSparkler, 1);
			_playState.setLumosity(2);					
		}
		
		*/
		
		if (changedFireworkType != 0) {
			setCurrentFireworkType(changedFireworkType);
		}
		
		if (useItem) {	
			if (_holdingFirework == null) {
				switch(currentFireworkType) {
					case 1:
						_holdingFirework = new Sparkler(_playState, this);
						_playState.addFirework(_holdingFirework);
					case 3:
						_holdingFirework = new BottleRocket(_playState, this);
						_playState.addFirework(_holdingFirework);
					default:					
				}
				
			} else {
				_holdingFirework = null;
			}
		}
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
					
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
		}
		
		if (_togglefw1)
		{
		 _playState._hud.toggleFw(1);
		}
		
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			_sndStep.play();
			
			switch(facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
					
				case FlxObject.UP:
					animation.play("u");
					
				case FlxObject.DOWN:
					animation.play("d");
			}
		}
		
	}
	
	override public function update():Void 
	{
		movement();
		super.update();
		_candle.updatePosition(x, y);
		
		
		_playState.addLightSource(getGraphicMidpoint().subtractPoint(offset), 30);
		if (_holdingFirework != null && !_holdingFirework.isDone) {			
			_holdingFirework.setPosition(this.getGraphicMidpoint());
		} else if (_holdingFirework != null && _holdingFirework.isDone) {
			_holdingFirework = null;
		}
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		_candle = FlxDestroyUtil.destroy(_candle);
		_sndStep = FlxDestroyUtil.destroy(_sndStep);
	}
}
