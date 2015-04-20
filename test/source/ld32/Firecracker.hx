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
		super(1.5, playState, player, explosion);		
	}
	
	public override function wallCollision(particle:FlxParticle, tile:FlxTilemap):Void {
		particle.velocity.set(particle.velocity.x * 0.1, particle.velocity.y * 0.1);
		particle.acceleration.set(0, 0);
	}
	
	public override function enemyCollision(particle:FlxParticle, enemy:Enemy):Void {		
		enemy.hurt(10);
	}
	
	public override function getTypeId():Int {
		return 1;
	}
}