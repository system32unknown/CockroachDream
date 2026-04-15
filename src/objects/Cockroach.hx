package objects;

import states.PlayState;

enum abstract RoachStates(String) from String to String {
	var IDLE:RoachStates = "idle";
	var STOP:RoachStates = "stop";
	var MOVE:RoachStates = "move";
	var HIT:RoachStates = "hit";
}

class Cockroach extends FlxSprite {
	final RNG_FPS:Float = 15;
	public var state:RoachStates = IDLE;

	public var hit_ok:Bool = false;

	public var spd:Float = 0;
	public var spd_max:Int = 0;
	public var dir:Int = 0;
	
	public var pat:Int = 0;

	public var cnt:Float = 0.0;
	var animTimer:Float = 0.0;

	public var cnt_max:Float = 0.0;
	public var wait_max:Float = 0.0;

	var originalY:Float = 0.0;
	var yadd:Float = 0.0;

	var addx:Array<Float> = [];
	var addy:Array<Float> = [];

	public function new(x:Float = -100, y:Float = -100) {
		super(x, y);
		loadGraphic(Paths.image('play/cockroach'), true, 48, 48);
		animation.add('cock', [for (i in 0...frames.frames.length) i], 0, false);
		animation.play('cock', true);
		
		visible = false;

		spd = spd_max = 0;
		cnt = pat = 0;
		wait_max = cnt_max = 0.0;

		initDirections();
		state = IDLE;
	}

	public function appear():Void {
		visible = true;
		hit_ok = true;

		switch (FlxG.random.int(0, 2)) {
			case 0: setPosition(-4, FlxG.random.float(0, FlxG.height));
			case 1: setPosition(664, FlxG.random.float(0, FlxG.height));
			default: setPosition(FlxG.random.float(0, FlxG.width), -24);
		}

		spd_max = FlxG.random.int(2, 6);
		dir = getDir(x, y, 320, 240);
		enterStop();
	}

	public function getDir(x1:Float, y1:Float, x2:Float, y2:Float):Int {
		var dx:Float = x2 - x1;
		var dy:Float = y2 - y1;

		var adx:Float = Math.abs(dx);
		var ady:Float = Math.abs(dy);

		if (dx < 0) {
			if (dy < 0) return (ady > adx) ? 0 : 1;
			return (adx > ady) ? 2 : 3;
		}

		if (dy > 0) return (ady > adx) ? 4 : 5;
		return (adx > ady) ? 6 : 7;
	}

	function runaway():Void {
		var mx:Int = FlxG.mouse.x;
		var my:Int = FlxG.mouse.y;

		final range:Int = 100;

		if (mx < x - range) return;
		if (mx > x + range) return;
		if (my < y - range) return;
		if (my > y + range) return;
		dir = getDir(mx, my, x, y);

		spd = FlxG.random.int(6, 10);
		enterMove();
	}

	function initDirections():Void {
		final MAX_DIR:Int = 8;
		for (i in 0...MAX_DIR) {
			var rotation:Float = Math.PI * (i * 2 + 1) / MAX_DIR;
			addx.push(-Math.sin(rotation));
			addy.push(-Math.cos(rotation));
		}
	}

	function enterStop():Void {
		state = STOP;
		wait_max = FlxG.random.float(50, 100) / 30;
		animTimer = 0.0;
		cnt = pat = 0;
	}

	function updateStop(e:Float):Void {
		updatePatAnimation(1 + dir * 8 + pat);
		cnt += e;

		animTimer += e;
		if (animTimer > .1) {
			animTimer = 0;
			pat++;
			if (pat >= 4) pat = 0;
		}

		if (PlayState.instance.checkHit(x, y)) PlayState.instance.tell_touch();
		if (cnt > wait_max) {
			if (FlxG.random.int(0, 4) < 1) {
				dir = getDir(x, y, 320, 240);
			} else {
				if (FlxG.random.int(0, 4) > 1) dir = getDir(x, y, 320, 240); // go toward center
				else dir = FlxMath.wrap(dir + (FlxG.random.bool() ? 1 : -1), 0, 7); // random turn
			}
			spd = spd_max;
			enterMove();
		} else runaway();
	}

	function enterMove():Void {
		state = MOVE;
		cnt_max = FlxG.random.float(10, 30) / RNG_FPS;
		cnt = pat = 0;
	}

	function updateMove(e:Float):Void {
		x += addx[dir] * spd;
		y += addy[dir] * spd;

		updatePatAnimation(1 + dir * 8 + 4 + pat);
		pat++;
		if (pat >= 3) pat = 0;
		if (PlayState.instance.checkHit(x, y)) PlayState.instance.tell_touch();

		cnt += e;
		if (cnt >= cnt_max) {
			if (x < 0 || x > FlxG.width || y < 0 || y > FlxG.height) appear();
			else enterStop();
		}
	}

	public function hit():Void {
		if (!hit_ok) return;

		state = HIT;
		hit_ok = false;
		originalY = y;
		yadd = -28;
		cnt = 0;
		animTimer = 0.0;
		dir = FlxG.random.int(0, 8);
	}

	function updateHit(e:Float):Void {
		y += yadd;
		if (y > originalY) y = originalY;
		yadd += 5;
		dir++;
		if (dir >= 8) dir = 0;
		updatePatAnimation(1 + dir * 8 + 7);

		animTimer += e;
		if (animTimer >= .5) {
			updatePatAnimation(1 + dir * 8 + 6);
			state = IDLE;
		}
	}

	inline function updatePatAnimation(frame:Int):Void {
		animation.frameIndex = frame - 1;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		switch (state) {
			case IDLE:
			case STOP: updateStop(elapsed);
			case MOVE: updateMove(elapsed);
			case HIT: updateHit(elapsed);
		}
	}
}