package ld32;


import flixel.effects.particles.FlxParticle;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class Firecracker extends Firework
{

	public function new(playState:PlayState, player:Player) 
	{	
		var explosion = new FirecrackerExplosion(player.x, player.y, 0);		
		super(3, playState, player, explosion);		
	}
	
	public override function wallCollision(particle:FlxParticle, tile:FlxTilemap):Void {
		particle.velocity.set(particle.velocity.x * 0.25, particle.velocity.y * 0.25);
		particle.acceleration.set(0, 0);
	}
	
	public override function getTypeId():Int {
		return 2;
	}
}