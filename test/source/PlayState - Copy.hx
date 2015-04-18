package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxAngle;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import source.Player;
import ld32.Sparkler;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import source.Enemy;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _sparkler:Sparkler;
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_map = new FlxOgmoLoader("assets/data/test.oep");
		_mWalls = _map.loadTilemap("assets/images/tiles.png", 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		add(_player);
		
		
		
		add(_sparkler);
		super.create();	
		
	}
	
	private function placeEntities(entityName:String, entityData:Xml):Void
		{
			var x:Int = Std.parseInt(entityData.get("x"));
			var y:Int = Std.parseInt(entityData.get("y"));
				if (entityName == "player")
					{
						_player.x = x;
						_player.y = y;
						_sparkler = new Sparkler(x, y);
						_sparkler.init();

					}
				else if (entityName == "enemy")
					{
						_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
					}
		}
	
		
	private function checkEnemyVision(e:Enemy):Void
		{
			if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
				{
					e.seesPlayer = true;
					e.playerPos.copyFrom(_player.getMidpoint());
				}
			else
				e.seesPlayer = false;
		}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		
		_sparkler.destroy();
		_sparkler = null;
	}
	
	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_grpEnemies, _mWalls);
		_grpEnemies.forEachAlive(checkEnemyVision);
		_sparkler.at(_player);
	}	
}