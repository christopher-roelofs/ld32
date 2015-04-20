package ld32;
import flixel.effects.particles.FlxParticle;
import flixel.tile.FlxTilemap;
/**
 * ...
 * @author ...
 */
class Sparkler extends Firework
{

	public function new(playState:PlayState, player:Player) 
	{
		super(0, playState, player, new SparklerExplosion(player.x, player.y, 0));
		
	}
	
	public override function getTypeId():Int {
		return 0;
	}
	
	public override function enemyCollision(particle:FlxParticle, enemy:Enemy):Void {		
		enemy.hurt(5);
	}
	
}