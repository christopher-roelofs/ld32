package ld32;

import flixel.effects.particles.FlxParticle;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class BottleRocket extends Firework
{
	private var speed:Float = 500;
	private var launched:Bool;
	private var velocity:FlxPoint;

	public function new(playState:PlayState, player:Player) 
	{	
		var explosion = new BottleRocketExplosion(player.x, player.y, 0);		
		velocity = new FlxPoint();
		super(1, playState, player, explosion);		
	}

	
	public override function getTypeId():Int {
		return 2;
	}
	
	public override function launch(direction:Float):Void {
		
		direction *= 0.017453293;
		velocity.x = Math.cos(direction) * speed;
		velocity.y = Math.sin(direction) * speed;
		
		launched = true;
		
	}
	
	public override function enemyCollision(particle:FlxParticle, enemy:Enemy):Void {		
		enemy.hurt(10);
	}
	
	public override function update():Void {
		
		if (launched) {
			var position = new FlxPoint(explosion.x, explosion.y);
			explosion.setPosition(position.x + FlxG.elapsed * velocity.x, position.y + FlxG.elapsed * velocity.y);
			
		}
		super.update();
	}
}