package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
using flixel.util.FlxSpriteUtil;
import ld32.Sparkler;


/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _player:Player;
	private var _map:FlxOgmoLoader;
	private var _mWalls:FlxTilemap;
	private var _grpCoins:FlxTypedGroup<Coin>;
	private var _grpContainers:FlxTypedGroup<Container>;
	private var _grpEnemies:FlxTypedGroup<Enemy>;
	private var _hud:HUD;
	private var _money:Int = 0;
	private var _health:Int = 3;
	private var _inCombat:Bool = false;
	private var _combatHud:CombatHUD;
	private var _ending:Bool;
	private var _won:Bool;
	private var _paused:Bool;
	private var _sndCoin:FlxSound;
	//private var _sparkler:Sparkler;
	
	#if mobile
	public static var virtualPad:FlxVirtualPad;
	#end

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_map = new FlxOgmoLoader(AssetPaths.room_001__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		add(_mWalls);
		
		_grpCoins = new FlxTypedGroup<Coin>();
		add(_grpCoins);
		
		_grpContainers = new FlxTypedGroup<Container>();
		add(_grpContainers);
		
		_grpEnemies = new FlxTypedGroup<Enemy>();
		add(_grpEnemies);
		
		_player = new Player();
		
		_map.loadEntities(placeEntities, "entities");
		
		_player.addToPlayState(this);
		
		//add(_sparkler);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, 1);
		
		_hud = new HUD();
		add(_hud);
		
		
		_sndCoin = FlxG.sound.load(AssetPaths.coin__wav);
		
		#if mobile
		virtualPad = new FlxVirtualPad(FULL, NONE);		
		add(virtualPad);
		#end
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
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
			//_sparkler = new Sparkler(x, y);
			//_sparkler.init();
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(x + 4, y + 4));
			
		}
		else if (entityName == "container")
		{
			_grpContainers.add(new Container(x + 4, y + 4));
			
		}
		else if (entityName == "enemy")
		{
			_grpEnemies.add(new Enemy(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_player = FlxDestroyUtil.destroy(_player);
		_mWalls = FlxDestroyUtil.destroy(_mWalls);
		_grpCoins = FlxDestroyUtil.destroy(_grpCoins);
		_grpEnemies = FlxDestroyUtil.destroy(_grpEnemies);
		_grpContainers = FlxDestroyUtil.destroy(_grpContainers);
		_hud = FlxDestroyUtil.destroy(_hud);
		_combatHud = FlxDestroyUtil.destroy(_combatHud);
		_sndCoin = FlxDestroyUtil.destroy(_sndCoin);
		#if mobile
		virtualPad = FlxDestroyUtil.destroy(virtualPad);
		#end
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (_ending)
		{
			return;
		}
		
		if (!_inCombat)
		{
			FlxG.collide(_player, _mWalls);
			FlxG.overlap(_player, _grpCoins, playerTouchCoin);
			FlxG.overlap(_player, _grpContainers, playerTouchContainer);
			FlxG.collide(_grpEnemies, _mWalls);
			_grpEnemies.forEachAlive(checkEnemyVision);
			//FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
		}
	}
	
	private function doneFadeOut():Void 
	{
		FlxG.switchState(new GameOverState(_won, _money));
	}
	
	private function playerTouchEnemy(P:Player, E:Enemy):Void
	{
		if (P.alive && P.exists && E.alive && E.exists && !E.isFlickering())
		{
			startCombat(E);
		}
	}
	
	private function startCombat(E:Enemy):Void
	{
		_inCombat = true;
		_player.active = false;
		_grpEnemies.active = false;
		_combatHud.initCombat(_health, E);
		#if mobile
		virtualPad.visible = false;
		#end
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
	
	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			_sndCoin.play(true);
			_money++;
			_hud.updateHUD(_health, _money);
			C.kill();
		}
	}
	
	private function playerTouchContainer(P:Player, C:Container):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
		}
	}
}
