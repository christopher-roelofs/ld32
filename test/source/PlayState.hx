package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flash.display.Graphics;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxVirtualPad;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flash.filters.ColorMatrixFilter;
import flash.geom.Rectangle;
import openfl.display.BitmapData;
using flixel.util.FlxSpriteUtil;
import flash.geom.Point;
import ld32.SparklerExplosion;
import ld32.Firework;
import flixel.util.FlxTimer;


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
	private var _grpExit:FlxTypedGroup<Exit>;
	public var _hud:HUD;
	private var _money:Int = 0;	
	private var _inCombat:Bool = false;	
	private var _ending:Bool;
	private var _won:Bool;
	private var _paused:Bool;
	private var _sndCoin:FlxSound;
	private var _lightFilter:ColorMatrixFilter;
	private var _darkFilter:ColorMatrixFilter;
	private var _frameBuffer:BitmapData;	
	private var _lightSourceBuffer:FlxSprite;
	private var _darkBuffer:FlxSprite;	
	private var _lightSourceMask:FlxSprite;
	private var _darkMask:FlxSprite;
	private var _nonHudRect:Rectangle;
	private var _nonHudPoint:Point;
	private var _coolDown:Bool = false;
	private var _enemyTouchCooldownTimer:FlxTimer;
	
	private var _fireworks:Array<Firework>;
	
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
		
		_map = new FlxOgmoLoader(AssetPaths.room_002__oel);
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
		
		_grpExit = new FlxTypedGroup<Exit>();
		add(_grpExit);
		
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
		
		
		_darkFilter = new ColorMatrixFilter([0.5,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,0.25,0]);	
		//_lightFilter = new ColorMatrixFilter([1,0,0,0,0, 0,1,0,0,0, 0,0,0.75,0,0, 0,0,0,1,0]);	
		
		_nonHudRect = new Rectangle(0, 20, FlxG.camera.width, FlxG.camera.height - 20);
		_nonHudPoint = new Point(0, 20);
		
		_lightSourceMask = new FlxSprite(0, 0);
		_lightSourceMask.pixels = new BitmapData(FlxG.camera.width, FlxG.camera.height - 20, true, 0x00000000);
		_darkMask = new FlxSprite(0, 0);
		_darkMask.pixels = new BitmapData(FlxG.camera.width, FlxG.camera.height - 20, true, 0xFFFFFFFF);
		_frameBuffer = new BitmapData(FlxG.camera.width, FlxG.camera.height - 20, true, 0x00000000);		
		_lightSourceBuffer = new FlxSprite(0, 0);
		_lightSourceBuffer.pixels = new BitmapData(FlxG.camera.width, FlxG.camera.height - 20, true, 0x00000000);
		_darkBuffer = new FlxSprite(0, 0);
		_darkBuffer.pixels = new BitmapData(FlxG.camera.width, FlxG.camera.height - 20, true, 0x00000000);
		

		_fireworks = new Array<Firework>();
		
		super.create();	
		
	}
	
	public function setLumosity(lumosity:Float) {
		_lightFilter = new ColorMatrixFilter([1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0.75, 0, 0, 0, 0, 0, lumosity, 0]);

	}
	
	public function addFirework(firework:Firework):Void {
		_fireworks.push(firework);				
	}
	
	public function removeFirework(firework:Firework):Void {
		_fireworks.remove(firework);
		
		firework.destroy();
		firework = null;
	}
	
	public function addLightSource(point:FlxPoint, radius:Float):Void
	{
		point.set(point.x - (FlxG.camera.scroll.x), point.y - (FlxG.camera.scroll.y));
		FlxSpriteUtil.drawCircle(_lightSourceMask, point.x - _nonHudPoint.x, point.y - _nonHudPoint.y, radius, FlxColor.WHITE, { color: FlxColor.WHITE, thickness: 1}, { color: FlxColor.WHITE, alpha: 1});
		FlxSpriteUtil.drawCircle(_darkMask, point.x - _nonHudPoint.x, point.y - _nonHudPoint.y, radius, FlxColor.TRANSPARENT, { color: FlxColor.TRANSPARENT, thickness: 1 }, { color: FlxColor.TRANSPARENT, alpha: 1 } );
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
		else if (entityName == "container")
		{
			_grpContainers.add(new Container(x, y));
			
		}
		else if (entityName == "enemy")
		{
			var enemy = new Enemy(x + 4, y, Std.parseInt(entityData.get("etype")));
			enemy.health = 20;
			_grpEnemies.add(enemy);
		}
		else if (entityName == "exit")
		{
			_grpExit.add(new Exit(x,y));
			
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
		
		_lightSourceMask.fill(0x00000000);
		_darkMask.fill(0xFFFFFFFF);
		
		super.update();

		if (_ending)
		{
			return;
		}
		
		if (!_inCombat)
		{
			FlxG.collide(_player, _mWalls);
			FlxG.overlap(_player, _grpContainers, playerTouchContainer);
			FlxG.overlap(_player, _grpExit, playerTouchExit);
			FlxG.collide(_grpEnemies, _mWalls);
			_grpEnemies.forEachAlive(checkEnemyVision);
			FlxG.overlap(_player, _grpEnemies, playerTouchEnemy);
		}
		
		for (i in 0..._fireworks.length) {
			_fireworks[i].update();
			if(_fireworks[i].shouldCollide()) {
				FlxG.collide(_fireworks[i].explosion, _mWalls, _fireworks[i].wallCollision);
			}
		}
		
		for (i in 0..._fireworks.length) {
			FlxG.collide(_fireworks[i].explosion, _grpEnemies, _fireworks[i].enemyCollision);
		}
		
	}
	
	override public function draw():Void 
	{
		super.draw();
		
		_lightSourceBuffer.pixels.copyPixels(FlxG.camera.buffer, _nonHudRect, new Point());
		_darkBuffer.pixels.copyPixels(FlxG.camera.buffer, _nonHudRect, new Point());
		FlxSpriteUtil.alphaMaskFlxSprite(_lightSourceBuffer, _lightSourceMask, _lightSourceBuffer);
		_lightSourceBuffer.dirty = true;
		_lightSourceBuffer.drawFrame(true);
		_lightSourceBuffer.framePixels.applyFilter(_lightSourceBuffer.framePixels, _lightSourceBuffer.framePixels.rect, new Point(), _lightFilter);		
		FlxSpriteUtil.alphaMaskFlxSprite(_darkBuffer, _darkMask, _darkBuffer);
		_darkBuffer.dirty = true;
		_darkBuffer.drawFrame(true);
		_darkBuffer.framePixels.applyFilter(_darkBuffer.framePixels, _darkBuffer.framePixels.rect, new Point(), _darkFilter);
		_darkBuffer.framePixels.copyPixels(_lightSourceBuffer.framePixels, _lightSourceBuffer.framePixels.rect, new Point(), null, null, true);

		FlxG.camera.buffer.copyPixels(_darkBuffer.framePixels, _darkBuffer.framePixels.rect, _nonHudPoint);
		
	}
	
	
	private function doneFadeOut():Void 
	{
		FlxG.switchState(new GameOverState(_won,_player));
	}
	
	
private function enemyCoolDown(timer:FlxTimer):Void
 {
  _coolDown = false;
 }
 
 
 public function goToGameOver():Void {
	FlxG.switchState(new GameOverState(false,_player));
 }
 
	private function playerTouchEnemy(P:Player, E:Enemy):Void
 {
  if (_coolDown == false)
	{
		 P.addHealth( -1);
		_coolDown = true;
		_enemyTouchCooldownTimer = new FlxTimer(1, enemyCoolDown, 1);
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
	
private function playerTouchContainer(P:Player, C:Container):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			P.updateBoxesCollectedCount();
			P.updateFwInventory(FlxRandom.intRanged(1, 5), FlxRandom.intRanged(1,5));
			C.kill();
			
		}
	}
	

	
	private function playerTouchExit(P:Player, E:Exit):Void
	{
		if (P.alive && P.exists && E.alive && E.exists)
		{
			FlxG.switchState(new GameOverState(true,_player));
		}
	}
}
