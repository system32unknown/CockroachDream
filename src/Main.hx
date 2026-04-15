package;

import debug.FPSCounter;
import openfl.Lib;

@:structInit
class GameData {
	public var initialState:flixel.util.typeLimit.NextState; // initial game state

	@:default(true)
	public var skipSplash:Bool; // if the default flixel splash screen should be skipped

	@:default(false)
	public var startFullscreen:Bool; // if the game should start at fullscreen mode
}

class Main extends openfl.display.Sprite {
	public static var verbose:Bool = false;

	public static final game:GameData = {
		initialState: states.TitleState,
		skipSplash: true,
		startFullscreen: false
	};

	public static var fpsVar:FPSCounter;

	public function new() {
		super();

		debug.Logs.init();

		var curStage:openfl.display.Stage = Lib.current.stage;
		addChild(new backend.CustomGame(() -> new Init(), Std.int(curStage.width), Std.int(curStage.height), Std.int(curStage.frameRate), game.skipSplash, game.startFullscreen));
		addChild(fpsVar = new FPSCounter());

		FlxG.signals.preStateSwitch.add(() -> if (Settings.data.autoCleanAssets) Paths.clearStoredMemory());
		FlxG.signals.postStateSwitch.add(() -> Paths.clearUnusedMemory());
		FlxG.signals.gameResized.add((w:Int, _:Int) -> @:privateAccess FlxG.game.soundTray._defaultScale = (w / FlxG.width) * 2);
	}
}