package ;

class FSM
{
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	
	
	public var activeState(null, default):Void->Void;
	
	public function new(?InitState:Void->Void):Void
	{
		activeState = InitState;
		_brain = new FSM(idle);
		_idleTmr = 0;
		playerPos = FlxPoint.get();
	}
	
	public function update():Void
	{
		if (activeState != null)
			activeState();
	}
	
	public function idle():Void
{
    if (seesPlayer)
    {
        _brain.activeState = chase;
    }
    else if (_idleTmr <= 0)
    {
        if (FlxRandom.chanceRoll(1))
        {
            _moveDir = -1;
            velocity.x = velocity.y = 0;
        }
        else
        {
            _moveDir = FlxRandom.intRanged(0, 8) <em> 45;
            FlxAngle.rotatePoint(speed </em> .5, 0, 0, 0, _moveDir, velocity);
        }
        _idleTmr = FlxRandom.intRanged(1, 4);<br>    }
    else
        _idleTmr -= FlxG.elapsed;
    }
}

public function chase():Void
{
    if (!seesPlayer)
    {
        _brain.activeState = idle;
    }
    else
    {
        FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
    }
}

override public function update():Void 
{
    _brain.update();
    super.update();
}
}