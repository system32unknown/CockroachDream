package states;

import objects.Cockroach;

typedef HitRow = {
	var st1:Int;
	var ed1:Int;
	var st2:Int;
	var ed2:Int;
	var st3:Int;
	var ed3:Int;
}

class PlayState extends flixel.addons.transition.FlxTransitionableState {
	public static var instance:PlayState;

	public var stress:Int = 0;
	public var stress_max:Int = 800;

	public var goki_touch:Bool = false;
	public var face_lev:Int = -1;

	public var goki_dead:Int = 0;
	public var gameover:Bool = false;

	public var beat_cnt:Int = 0;
	public var beat_interval:Int = 7;
	public var beat_ic:Int = 0;

	public var appear_cnt:Int = 0;
	public var appear_interval:Float = 80;

	public var goki_num:Int = 0;

	final ROACHES_MAX:Int = 100;

	var hitArray:Array<HitRow> = [];

	public function tell_touch():Void {
		goki_touch = true;
	}

	public function checkHit(px:Float, py:Float):Bool {
		var x:Int = Std.int(px);
		var y:Int = Std.int(py);

		if (y >= 0 && y < FlxG.height) {
			var row:HitRow = hitArray[y];
			if ((x > row.st1 && x < row.ed1) || (x > row.st2 && x < row.ed2) || (x > row.st3 && x < row.ed3)) return true;
		}
		return false;
	}

	public function buildHitArray(hitSprite:FlxSprite):Void {
		for (_ in 0...FlxG.height) hitArray.push({st1: 0, ed1: 0, st2: 0, ed2: 0, st3: 0, ed3: 0});

		for (i in 80...FlxG.height) {
			var c:Int = 0;
			var h:Bool = false;

			for (j in 160...FlxG.height) {
				if ((hitSprite.pixels.getPixel32(j, i) >> 24) != 0) {
					if (!h) {
						c++;

						switch (c) {
							case 1:
								hitArray[i].st1 = j;
								hitArray[i].ed1 = j;

							case 2:
								hitArray[i].st2 = j;
								hitArray[i].ed2 = j;

							case 3:
								hitArray[i].st3 = j;
								hitArray[i].ed3 = j;
						}
					} else {
						switch (c) {
							case 1: hitArray[i].ed1 = j;
							case 2: hitArray[i].ed2 = j;
							case 3: hitArray[i].ed3 = j;
						}
					}

					h = true;
				} else h = false;
			}
		}
	}

	var roachGroup:FlxTypedGroup<Cockroach>;

	override public function create() {
		super.create();
		FlxG.mouse.visible = false;

		var bg:FlxSprite = new FlxSprite(Paths.image('bg'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.gameCenter();
		add(bg);

		var collision:FlxSprite = new FlxSprite(Paths.image('play/collision'));
		collision.alpha = 0;
		add(collision);
		buildHitArray(collision);

		add(roachGroup = new FlxTypedGroup<Cockroach>());

		for (i in 0...ROACHES_MAX) {
			roachGroup.add(new Cockroach());
		}

		add(new objects.Paper());

		instance = this;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (!gameover) {
			handleSpawn();
			handleStress();
		}
		handleClick();
	}

	function handleSpawn():Void {
		appear_cnt++;

		if (appear_cnt > appear_interval) {
			appear_cnt = 0;

			if (goki_num < ROACHES_MAX) {
				roachGroup.members[goki_num].appear();
				goki_num++;
			}

			appear_interval -= 2;
			if (appear_interval < 20) appear_interval = 20;
		}
	}

	function handleStress():Void {
		if (goki_touch) {
			goki_touch = false;

			stress++;

			// mcStress.add_stress(...)
			// updateStressBar();

			var lev:Int = Std.int(stress / (stress_max / 6));
			if (lev > 6) lev = 6;

			if (lev != face_lev) {
				face_lev = lev;
				// updateFace(lev);
			}

			if (stress >= stress_max) {
				gameover = true;
				// onGameOver();
			}

			beat_interval = 6 - lev;
		}
	}

	function handleClick():Void {
		if (!FlxG.mouse.justPressed) return;

		var mx:Int = FlxG.mouse.x;
		var my:Int = FlxG.mouse.y;

		var hit:Bool = false;
		var w:Int = 24;

		for (i in 0...goki_num) {
			var g:Cockroach = roachGroup.members[i];

			if (g.hit_ok) {
				if (mx >= g.x - w && mx <= g.x + w && my >= g.y - w && my <= g.y + w) {
					g.hit();
					goki_dead++;
					hit = true;
				}
			}
		}

		if (hit) {
			// updateKillCount();

			if (goki_dead >= ROACHES_MAX) {
				// onClear();
			}

			FlxG.sound.play(Paths.audio('sounds/hit'));
		} else FlxG.sound.play(Paths.audio('sounds/tap'));
	}
}
