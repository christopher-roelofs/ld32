package ld32;

import flixel.effects.particles.FlxParticle;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author ...
 */
class Dahlia extends Firework
{

	public function new(playState:PlayState, player:Player) 
	{	
		var explosion = new DahliaExplosion(player.x, player.y, 0);		
		super(3, playState, player, explosion);		
	}
	
	public override function getTypeId():Int {
		return 3;
	}
	
	public override function enemyCollision(particle:FlxParticle, enemy:Enemy):Void {		
		enemy.hurt(30);
	}
	
}