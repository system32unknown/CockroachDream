package;

class Main extends openfl.display.Sprite {
	public function new() {
		super();

		debug.CrashHandler.init();
		addChild(new flixel.FlxGame(TitleState, 640, 480, true));
		addChild(new debug.FPSCounter());
	}
}
