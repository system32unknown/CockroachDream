package objects;

enum Roach_States {
	NONE;
	STOP;
	MOVE;
	HIT;
}

class Cockroach extends FlxSprite {
	var state:Roach_States;

	public var hit_ok:Bool = false;
	public var touch:Bool = false;

	public var spd:Float = 0;
	public var spd_max:Int = 0;
	public var dir:Int = 0;

	public var cnt:Int = 0;
	public var cnt_max:Int = 0;
	public var pat:Int = 0;
	public var wait_max:Int = 0;

	public var addx:Array<Float> = [];
	public var addy:Array<Float> = [];

	var originalYOffset:Float = 0.0;
	final oy:Float = -28;

	public var cockFrame(default, set):Int = 0;
	@:noCompletion function set_cockFrame(v:Int) {
		if (animation != null) animation.frameIndex = dir * 8 + v;
		return v;
	}

	public function new(x:Float, y:Float) {
		super(x, y);
		var graph:flixel.graphics.FlxGraphic = Paths.image('cockroach');
		loadGraphic(graph, true, 48, 48);
		animation.add('cock', [for (i in 0...frames.frames.length) i], 0, false);

		originalYOffset = offset.y;
		visible = false;

		initDirections();
		resetState();
	}

	function resetState():Void {
		cnt = 0;
		pat = 0;
		cnt_max = 10 + FlxG.random.int(0, 20);
		wait_max = 50 + FlxG.random.int(0, 50);
	}

	public function appear():Void {
		visible = true;
		hit_ok = true;

		switch (FlxG.random.int(0, 2)) {
			case 0:
				x = -24;
				y = FlxG.random.float(0, 480);

			case 1:
				x = 664;
				y = FlxG.random.float(0, 480);

			default:
				x = FlxG.random.float(0, 640);
				y = -24;
		}

		spd_max = 4 + FlxG.random.int(0, 4);
		dir = getDir(x, y, 320, 240);

		state = STOP;
		resetState();
	}

	public function runaway():Void {
		var mx:Int = FlxG.mouse.x;
		var my:Int = FlxG.mouse.y;

		final range:Int = 100;

		var dx:Float = mx - x;
		var dy:Float = my - y;

		if (Math.abs(dx) > range || Math.abs(dy) > range) return;
		dir = getDir(mx, my, x, y);

		spd = 7 + FlxG.random.int(0, 4);
		state = MOVE;
		resetState();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		switch (state) {
			case STOP:
				cnt++;

				if (cnt % 3 == 0)
					pat = (pat + 1) % 4;

				cockFrame = pat;

				if (touch) {
					// replace this with your actual callback
					// FlxG.state or parent system
					// Example:
					// cast(FlxG.state, PlayState).tell_touch();
				}

				if (cnt > wait_max) {
					if (FlxG.random.float() < 0.25) dir = getDir(x, y, 320, 240); // go toward center
					else dir = FlxMath.wrap(dir + (FlxG.random.bool() ? -1 : 1), 0, 7); // random turn

					spd = spd_max;
					state = MOVE;
				} else runaway();
			case MOVE:
				velocity.set(addx[dir] * spd * 60, addy[dir] * spd * 60);
				cockFrame = 4 + pat;

				pat++;
				if (pat >= 3) pat = 0;
				if (touch) {
					// replace this with your actual callback
					// FlxG.state or parent system
					// Example:
					// cast(FlxG.state, PlayState).tell_touch();
				}
				cnt++;
				if(cnt >= cnt_max) {
					if (x < 0 || x > 640 || y < 0 || y > 480) appear();
					else state = STOP;
				}

			case HIT:
				offset.y += -28;
				if (offset.y > oy) offset.y = oy;
				offset.y += 5;

				if (dir >= 8) dir = 0;
				cockFrame = 7;
				cnt++;
				if (cnt > 30) cockFrame = 6;

			case NONE:
		}
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

	function initDirections():Void {
		for (i in 0...8) {
			var rotation:Float = Math.PI * (i * 2 + 1) / 8;
			addx.push(-Math.sin(rotation));
			addy.push(-Math.cos(rotation));
		}
	}

	public function hit():Void {
		if (!hit_ok) return;

		hit_ok = false;
		state = HIT;
		resetState();
	}
}