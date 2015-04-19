package ld32;

import flixel.util.FlxTimer;
import openfl.geom.Point;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class Firework
{


	public var fuseTime:Float;
	private var _fuseTimer:FlxTimer;
	private var _explosionTimer:FlxTimer;
	private var _playState:PlayState;
	private var _player:Player;
	private var _fuseExpired:Bool;
	public var fuse:Fuse;
	public var explosion:Explosion;
	public var isDone:Bool;
	
	
	public function new(fuseTimeDuration:Float, playState:PlayState, player:Player, explooooosion:Explosion) {
		_playState = playState;
		_player = player;
		fuseTime = fuseTimeDuration;
		explosion = explooooosion;
		explosion.init(this, playState, player);
	if(fuseTime > 0) {
		_fuseTimer = new FlxTimer(fuseTimeDuration, fuseExpired, 1);
		fuse = new Fuse(_player.x, _player.y);
		fuse.init();		
		_playState.add(fuse);		
	} else {
		_fuseExpired = true;
		_playState.add(explosion);
		explosion.activate();
		_explosionTimer = new FlxTimer(explosion.duration(), explosionExpired, 1);
	}
		isDone = false;
		
	}

	public function setPosition(pos:FlxPoint):Void {
		
		if(!_fuseExpired) {
			fuse.setPosition(pos.x, pos.y);
			explosion.setPosition(pos.x, pos.y);
		}
		
	}
	public function fuseExpired(timer:FlxTimer):Void {		
		_fuseExpired = true;
		fuse.on = false;
		fuse.visible = false;		
		_playState.remove(fuse);		
		_playState.add(explosion);		
		explosion.activate();
		_explosionTimer = new FlxTimer(explosion.duration(), explosionExpired, 1);
		
	}
	
	public function shouldCollide():Bool {
		return (_fuseExpired && explosion.collides);
	}
	
	public function explosionExpired(timer:FlxTimer):Void {
		isDone = true;
		_playState.remove(explosion);
		_playState.removeFirework(this);		
	}
	
	public function destroy():Void {
		if(fuseTime > 0) {
			fuse.destroy();
		}
		explosion.destroy();
	}
	
	public function update():Void {
		if (!_fuseExpired) {
			var pos = new FlxPoint(fuse.x, fuse.y);
			_playState.addLightSource(pos, 20);
		}
	}
	
	
}