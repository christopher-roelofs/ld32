package ld32;

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
		return 4;
	}
	
}