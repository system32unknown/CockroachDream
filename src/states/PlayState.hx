package states;

class PlayState extends flixel.FlxState {
	var stress = 0;
	var stress_max = 800;
	var goki_touch = 0;
	var face_lev = -1;
	var goki_dead = 0;
	var gameover = 0;
	var beat_interval = 7;
	var appear_interval = 80;
	var appear_cnt = 0;
	var goki_num = 0;
	var gokis = [];

	override public function create() {
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}
