package ld32;

/**
 * ...
 * @author ...
 */
class BottleRocket extends Firework
{

	public function new(playState:PlayState, player:Player) 
	{	
		var explosion = new BottleRocketExplosion(player.x, player.y, 0);		
		super(3, playState, player, explosion);		
	}

	
	
}