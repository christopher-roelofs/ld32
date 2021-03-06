package ld32;


import flixel.effects.FlxSpriteFilter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter.Bounds;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import openfl.filters.GlowFilter;
import flixel.system.FlxSound;
import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class BottleRocketExplosion extends Explosion
{
		private var _whitePixel:FlxParticle;
	private var _glowFilter:GlowFilter;
	private var _pixelFilter:FlxSpriteFilter;
	private var _velocity:FlxPoint;	
	
	public function new(X:Float=0, Y:Float=0, Size:Int=5) 
	{
		Size = 20;
		super(X, Y, Size);
		setAlpha(1, 1, 0, 0);
		rotation = new Bounds<Float>(0, 0);
		setMotion(0, 400, duration(), 360, 0, 0);		
		
		_glowFilter = new GlowFilter(0x2200FF,0.5,16,16,20,1,false,false);
	
		for (i in 0...(Std.int(maxSize))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(4, 4, FlxColor.AZURE);
			_whitePixel.visible = true; 
			_pixelFilter = new FlxSpriteFilter(_whitePixel, 10, 10);
			_pixelFilter.addFilter(_glowFilter, true);
			_whitePixel.width = 4;
			_whitePixel.height = 4;
			add(_whitePixel);
			
		}
		
		_explosionSound = FlxG.sound.load(AssetPaths.rocket__mp3,5);
		_frequency = 0.01;
		
	}
	
	public override function init(firework:Firework, playState:PlayState, player:Player):Void {
		super.init(firework, playState, player);		
	}
	
	
		public override function destroy():Void
	{
		_whitePixel = FlxDestroyUtil.destroy(_whitePixel);
		_pixelFilter.destroy();
	}
	
	public override function duration():Float {
		return 2;
	}
	
	
	public override function lightSourceRadius():Float {
		return 15;
	}
	

	
	public override function activate():Void {				
		super.start(false, 0.1, _frequency);
		_explosionSound.play();
		_firework.launch(_player.direction);
	}

	private override function setParticleMotion(Particle:FlxParticle, Angle:Float, Distance:Float, AngleRange:Float = 0, DistanceRange:Float = 0):Void
	{			
		//set particle direction and speed
		var a:Float = FlxRandom.floatRanged(Angle, Angle + AngleRange);
		var d:Float = FlxRandom.floatRanged(Distance, Distance + DistanceRange);
		
		Particle.velocity.x = Math.cos(a) * d;
		Particle.velocity.y = Math.sin(a) * d;
	}
	
	override public function emitParticle():Void
	{
		var particle:FlxParticle = cast recycle(cast _particleClass);
		particle.elasticity = bounce;
		
		particle.reset(x - (Std.int(particle.width) >> 1) + FlxRandom.float() * width, y - (Std.int(particle.height) >> 1) + FlxRandom.float() * height);
		particle.visible = true;
		
		if (life.min != life.max)
		{
			particle.lifespan = particle.maxLifespan = life.min + FlxRandom.float() * (life.max - life.min);
		}
		else
		{
			particle.lifespan = particle.maxLifespan = life.min;
		}
		
		if (startAlpha.min != startAlpha.max)
		{
			particle.startAlpha = startAlpha.min + FlxRandom.float() * (startAlpha.max - startAlpha.min);
		}
		else
		{
			particle.startAlpha = startAlpha.min;
		}
		particle.alpha = particle.startAlpha;
		
		var particleEndAlpha:Float = endAlpha.min;
		if (endAlpha.min != endAlpha.max)
		{
			particleEndAlpha = endAlpha.min + FlxRandom.float() * (endAlpha.max - endAlpha.min);
		}
		
		if (particleEndAlpha != particle.startAlpha)
		{
			particle.useFading = true;
			particle.rangeAlpha = particleEndAlpha - particle.startAlpha;
		}
		else
		{
			particle.useFading = false;
			particle.rangeAlpha = 0;
		}
		
		// particle color settings
		var startRedComp:Float = particle.startRed = startRed.min;
		var startGreenComp:Float = particle.startGreen = startGreen.min;
		var startBlueComp:Float = particle.startBlue = startBlue.min;
		
		var endRedComp:Float = endRed.min;
		var endGreenComp:Float = endGreen.min;
		var endBlueComp:Float = endBlue.min;
		
		if (startRed.min != startRed.max)
		{
			particle.startRed = startRedComp = startRed.min + FlxRandom.float() * (startRed.max - startRed.min);
		}
		if (startGreen.min != startGreen.max)
		{
			particle.startGreen = startGreenComp = startGreen.min + FlxRandom.float() * (startGreen.max - startGreen.min);
		}
		if (startBlue.min != startBlue.max)
		{
			particle.startBlue = startBlueComp = startBlue.min + FlxRandom.float() * (startBlue.max - startBlue.min);
		}
		
		if (endRed.min != endRed.max)
		{
			endRedComp = endRed.min + FlxRandom.float() * (endRed.max - endRed.min);
		}
		
		if (endGreen.min != endGreen.max)
		{
			endGreenComp = endGreen.min + FlxRandom.float() * (endGreen.max - endGreen.min);
		}
		
		if (endBlue.min != endBlue.max)
		{
			endBlueComp = endBlue.min + FlxRandom.float() * (endBlue.max - endBlue.min);
		}
		
		particle.rangeRed = endRedComp - startRedComp;
		particle.rangeGreen = endGreenComp - startGreenComp;
		particle.rangeBlue = endBlueComp - startBlueComp;
		
		particle.useColoring = false;
		
		if (particle.rangeRed != 0 || particle.rangeGreen != 0 || particle.rangeBlue != 0)
		{
			particle.useColoring = true;
		}
		
		// End of particle color settings
		if (startScale.min != startScale.max)
		{
			particle.startScale = startScale.min + FlxRandom.float() * (startScale.max - startScale.min);
		}
		else
		{
			particle.startScale = startScale.min;
		}
		particle.scale.x = particle.scale.y = particle.startScale;
		
		var particleEndScale:Float = endScale.min;
		
		if (endScale.min != endScale.max)
		{
			particleEndScale = endScale.min + Std.int(FlxRandom.float() * (endScale.max - endScale.min));
		}
		
		if (particleEndScale != particle.startScale)
		{
			particle.useScaling = true;
			particle.rangeScale = particleEndScale - particle.startScale;
		}
		else
		{
			particle.useScaling = false;
			particle.rangeScale = 0;
		}
		
		particle.blend = blend;
		
		// Set particle motion
		setParticleMotion(particle, angle, distance, angleRange, distanceRange);
		particle.acceleration.set(acceleration.x, acceleration.y);
		
		if (rotation.min != rotation.max)
		{
			particle.angularVelocity = rotation.min + FlxRandom.float() * (rotation.max - rotation.min);
		}
		else
		{
			particle.angularVelocity = rotation.min;
		}
		if (particle.angularVelocity != 0)
		{
			particle.angle = FlxRandom.float() * 360 - 180;
		}
		particle.drag.set(40, 40);
		particle.elasticity = 0.1;
		particle.onEmit();
	}
}	