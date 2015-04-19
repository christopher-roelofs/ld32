package ld32;

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
	
}