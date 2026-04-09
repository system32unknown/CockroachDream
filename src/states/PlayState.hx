package states;

class PlayState extends flixel.FlxState {
	var stress:Int = 0;
	var stress_max:Int = 800;
	var goki_touch:Int = 0;
	var face_lev:Int = -1;
	var goki_dead:Int = 0;
	var gameover:Int = 0;
	var beat_interval:Int = 7;
	var appear_interval:Int = 80;
	var appear_cnt:Int = 0;
	var goki_num:Int = 0;
	var gokis = [];

	override public function create() {
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	public static function hitTest():Bool {
		return false;
	}
}
