package ld32;

/**
 * ...
 * @author ...
 */
class BottleRocketExplosion extends Explosion
{

	public function new(X:Float=0, Y:Float=0, Size:Int=0) 
	{
		super(X, Y, Size);		
	}
	
	public override function init(firework:Firework, playState:PlayState, player:Player):Void {
		super.init(firework, playState, player);		
	}
	
	public override function activate():Void {
		super.activate();				
	}
	
	public override function duration():Float {
		return 4;
	}
	
}	