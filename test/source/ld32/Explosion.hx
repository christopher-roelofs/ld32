package ld32;

import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Explosion extends FlxEmitterExt
{

	private var _firework:Firework;
	private var _playState:PlayState;
	private var _player:Player;
	private var _frequency:Float;
	
	public var isFinished:Bool;
	public var isStarted:Bool;
	
	public var collides:Bool;
	private var _explosionSound:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);		
		isFinished = false;
		isStarted = false;
		collides = true;
		_frequency = 0.01;
		
	}
	
	public function init(firework:Firework, playState:PlayState, player:Player):Void {
		_firework = firework;
		_playState = playState;
		_player = player;		
	}
	
	public function activate():Void {		
		_explosionSound.play();
		super.start(false, duration(), _frequency);
	}
	
	public function addLightSource(particle:FlxParticle):Void {
		_playState.addLightSource(particle.getGraphicMidpoint(), lightSourceRadius());
	}
	
	public function lightSourceRadius():Float {
		return 10;
	}
	
	public function duration():Float {
		return 3;
	}
	
		public override function update():Void
	{
		super.update();
		forEach(addLightSource);
		
	}

	
}