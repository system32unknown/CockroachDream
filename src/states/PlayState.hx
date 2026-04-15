package states;

import objects.Face;
import objects.Cockroach;
import objects.StressBar;
import objects.Paper;

import substates.ResultSubstate;

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

	public var roach_dead:Int = 0;
	public var gameover:Bool = false;

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
	var stressbar:StressBar;
	var face:Face;

	var botplayTxt:FlxText;
	var botPlay:Bool = true;
	var noStress:Bool = true;

	var paper:Paper;

	override public function new() {
		super();

		paper = new Paper();
		paper.target.visible = false;
	}

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

		face = new Face(270, 100);
		face.scrollFactor.set();
		add(face);

		add(roachGroup = new FlxTypedGroup<Cockroach>());
		for (i in 0...ROACHES_MAX) roachGroup.add(new Cockroach());

		add(paper);
		paper.target.visible = true;

		stressbar = new StressBar(0, 457);
		stressbar.scrollFactor.set();
		add(stressbar);

		botplayTxt = new FlxText(400, stressbar.y - 30, FlxG.width - 800, "BOTPLAY", 16);
		botplayTxt.setFormat(botplayTxt.size, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.visible = botPlay;
		botplayTxt.gameCenter(X);
		add(botplayTxt);

		instance = this;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (gameover) return;

		handleSpawn();
		handleStress();
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
		if (noStress) return;

		if (goki_touch) {
			goki_touch = false;

			stress++;
			stressbar.bar.percent = 100 * (stress / stress_max);

			var lev:Int = Math.floor(stress / (stress_max / 6));
			if (lev > 6) lev = 6;

			if (lev != face_lev) {
				face_lev = lev;
				face.gotoLev(face_lev);
			}

			if (stress >= stress_max) {
				gameover = true;
				onGameOver();
			}
		}
	}

	function onGameOver():Void {
		openSubState(new ResultSubstate());
	}
	function onClear():Void {
		var result:ResultSubstate = new ResultSubstate();
		result.isVictory = true;
		openSubState(result);
	}

	override function openSubState(SubState:FlxSubState) {
		super.openSubState(SubState);
		FlxG.mouse.visible = true;
		paper.target.visible = false;
	}

	function handleClick():Void {
		if (!FlxG.mouse.justPressed) return;

		var mx:Int = FlxG.mouse.x;
		var my:Int = FlxG.mouse.y;

		var hit:Bool = false;
		var w:Int = 24;

		for (cockroach in roachGroup) {
			if (cockroach.hit_ok) {
				if (mx >= cockroach.x - w && mx <= cockroach.x + w && my >= cockroach.y - w && my <= cockroach.y + w) {
					cockroach.hit();
					roach_dead++;
					hit = true;
				}
			}
		}

		if (hit) {
			// updateKillCount();

			if (roach_dead >= ROACHES_MAX) {
				onClear();
			}

			FlxG.sound.play(Paths.audio('sounds/hit'));
		} else FlxG.sound.play(Paths.audio('sounds/tap'));
	}
}