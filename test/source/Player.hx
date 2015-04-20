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
import flixel.util.FlxRandom;
import haxe.Log;
import ld32.BottleRocket;
import ld32.Candle;
import ld32.Dahlia;
import ld32.Firecracker;
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
	private var _matches:Int = 0;
	private var _candle:Candle;
	private var _kills:Int = 0;
	private var _boxesCollected:Int = 0;
	private var _usedMatches:Int = 0;
	private var _sparklerTimer:FlxTimer;
	private var _holdingFirework:Firework;
	public var currentFireworkType:Int;
	private var _playState:PlayState;
	public var direction:Float;
	
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
	
	public function updateBoxesCollectedCount():Void
	{
		_boxesCollected++;
	}
	
	
	public function updateKillsCount():Void
	{
			_kills++;
	}
	
	public function getKillCount()
	{
		return _kills;
	}
	
	public function getBoxesCollected()
	{
		return _boxesCollected;
	}
	
	public function getUsedMatchesCount()
	{
		return _usedMatches;
	}
	

	
	public function addHealth(hp:Int) {
		health += hp;
		if (health == -1) {
			_playState.goToGameOver();
			health = 0;
		}
		if (health <= 0) {
			if (_matches > 0) {
				_matches--;
				_usedMatches++;
				_playState._hud.updateHUD(_matches);
				health = 3;
			}
		}
		updateLumosityForHealth();
	}

	private function updateLumosityForHealth() {
		_candle.visible = (health > 0);
		_playState.setLumosity(health / 3.0);
	}
	
	public function updateFwInventory(fw:Int, count:Int)
	{

		
		if (fw == 1)
		{
			_fw1+=count;
			
		}
		else if (fw == 2)
		{
			_fw2+=count;
		}
		else if (fw == 3)
		{
			_fw3+=count;
		}
		else if(fw == 4)
		{
			_fw4+=count;
		}
		else
 {
			if (health == 0) {
				setHealth(3);
			} else {
				_matches++;
				_playState._hud.updateHUD(_matches);
			}
			
		}
		
		_playState._hud.updateFwHUD(_fw1, _fw2, _fw3, _fw4);
		
		
	}
	
	public function randomFireworks():Void
	{
		var cherosiphon:Bool = FlxRandom.chanceRoll(100);
		var sultiBomb:Bool =  FlxRandom.chanceRoll(15);
		var bangFai:Bool =  FlxRandom.chanceRoll(30);
		var dahlia:Bool =  FlxRandom.chanceRoll(10);
		var match:Bool = FlxRandom.chanceRoll(20);
		
		if (cherosiphon)
		{
			_fw1 += FlxRandom.intRanged(1,5);
		}
		if (sultiBomb)
		{
			_fw2+= FlxRandom.intRanged(1,2);
		}
		if (bangFai)
		{
			_fw3 += FlxRandom.intRanged(1,3);
		}
		if (dahlia)
		{
			_fw4 += FlxRandom.intRanged(1,1);
		}
		if (match)
		{
			_matches += FlxRandom.intRanged(1, 1);
		}	
		
		_playState._hud.updateFwHUD(_fw1, _fw2, _fw3, _fw4);
		_playState._hud.updateHUD(_matches);
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
		direction = 0;
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
			if (health > 0 && _holdingFirework == null) {
				switch(currentFireworkType) {
					case 1:
						if(_fw1 > 0) {
							_holdingFirework = new Sparkler(_playState, this);
							_playState.addFirework(_holdingFirework);
							updateFwInventory(1,-1);
						}
					case 2:
						if(_fw2 > 0) {
							_holdingFirework = new Firecracker(_playState, this);
							_playState.addFirework(_holdingFirework);
							updateFwInventory(2,-1);							
						}
					case 3:
						if(_fw3 > 0) {						
							_holdingFirework = new BottleRocket(_playState, this);
							_playState.addFirework(_holdingFirework);
							updateFwInventory(3,-1);
						}
					case 4:
						if(_fw4 > 0) {
							_holdingFirework = new Dahlia(_playState, this);
							_playState.addFirework(_holdingFirework);
							updateFwInventory(4,-1);
						}
					default:					
				}
				
			} else if (_holdingFirework != null) {
				_holdingFirework.launch(facing);
				switch(_holdingFirework.getTypeId()) {
					case 1:						
						_holdingFirework = null;
					case 2:
						_holdingFirework = null;
					case 4:
						_holdingFirework = null;						
				}
			}
		}
		
		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;
		
		if ( _up || _down || _left || _right)
		{
			facing = 0;
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
				facing = facing | FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = facing | FlxObject.RIGHT;
			}
			direction = mA;
			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
		}
		
		if (_togglefw1)
		{
		 _playState._hud.toggleFw(1);
		}
		
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
		{
			//_sndStep.play();
			
			if((facing & (FlxObject.LEFT | FlxObject.RIGHT)) != 0) {
				animation.play("lr");
			} else if((facing & FlxObject.UP) != 0) {				
				animation.play("u");					
			} else if((facing & FlxObject.DOWN) != 0) {
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
			if (_holdingFirework.isFuseExpired && _holdingFirework.getTypeId() == 3) {
				_holdingFirework = null;
			} else {
				_holdingFirework.setPosition(this.getGraphicMidpoint());
			}
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
