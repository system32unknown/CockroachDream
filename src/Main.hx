package;

@:structInit
class GameData {
	@:default(640)
	public var width:Int; // WINDOW width

	@:default(480)
	public var height:Int; // WINDOW height

	public var initialState:flixel.util.typeLimit.NextState; // initial game state

	@:default(60)
	public var framerate:Int; // default framerate

	@:default(true)
	public var skipSplash:Bool; // if the default flixel splash screen should be skipped

	@:default(false)
	public var startFullscreen:Bool; // if the game should start at fullscreen mode
}

class Main extends openfl.display.Sprite {
	public static var verbose:Bool = false;

	public static final game:GameData = {
		width: 640,
		height: 480,
		initialState: states.TitleState,
		framerate: 60,
		skipSplash: true,
		startFullscreen: false
	};

	public function new() {
		super();

		debug.Logs.init();
		addChild(new flixel.FlxGame(() -> new Init(), game.width, game.height, game.framerate, game.skipSplash, game.startFullscreen));
		addChild(new debug.FPSCounter());
	}
}