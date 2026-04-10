package backend;

class CustomGame extends flixel.FlxGame {
	public function new(?initialState:flixel.util.typeLimit.NextState, ?gameWidth:Int = 0, ?gameHeight:Int = 0, ?framerate:Int = 60, ?skipSplash:Bool = false, ?startFullscreen:Bool = false) {
		super(initialState, gameWidth, gameHeight, framerate, skipSplash, startFullscreen);
		_customSoundTray = CustomSoundTray;
	}

	var skipNextTickUpdate:Bool = false;

	public override function switchState() {
		super.switchState();
		draw();
		_total = ticks = getTicks();
		skipNextTickUpdate = true;
	}

	public override function onEnterFrame(t:openfl.events.Event) {
		if (skipNextTickUpdate != (skipNextTickUpdate = false)) _total = ticks = getTicks();
		super.onEnterFrame(t);
	}
}