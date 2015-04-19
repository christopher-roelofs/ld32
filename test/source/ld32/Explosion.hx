package ld32;

import flixel.effects.particles.FlxEmitterExt;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class Explosion extends FlxEmitterExt
{

	private var _firework:Firework;
	private var _playState:PlayState;
	private var _player:Player;
	
	
	public var isFinished:Bool;
	public var isStarted:Bool;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);		
		isFinished = false;
		isStarted = false;
	}
	
	public function init(firework:Firework, playState:PlayState, player:Player):Void {
		_firework = firework;
		_playState = playState;
		_player = player;		
	}
	
	public function activate():Void {		
		super.start(false, .25, 0.01);
	}
	
	public function duration():Float {
		return 3;
	}

	
}