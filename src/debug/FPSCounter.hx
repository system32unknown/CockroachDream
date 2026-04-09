package debug;

import utils.FPSUtil;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;

/**
 * The FPS class provides an easy-to-use monitor to display
 * the current framerate of an OpenFL project
 */
class FPSCounter extends openfl.text.TextField {
	public var fontName:String = "_sans";

	public var checkLag:Bool = true;
	public var updateRate:Float = 60;
	public var memDisplay:String = "";

	public var fpsManager:FPSUtil;

	/**
	 * The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
	 */
	public var gcMEM(get, never):Float;

	@:noCompletion function get_gcMEM():Float {
		var mem:Float = openfl.system.System.totalMemoryNumber;
		if (mem > gcPeakMEM)
			gcPeakMEM = mem;
		return mem;
	}

	var gcPeakMEM:Float = 0;

	@:noCompletion var lastText:String = null;

	public function new(x:Float = 0, y:Float = 0) {
		super();

		this.x = x;
		this.y = y;

		autoSize = LEFT;
		selectable = mouseEnabled = false;
		text = "0FPS";
		defaultTextFormat = new openfl.text.TextFormat(fontName, 12, -1, JUSTIFY);

		sharpness = 100;
		multiline = true;
		fpsManager = new FPSUtil();
	}

	public dynamic function preUpdateText():Void {
		if (!checkLag) return;
		textColor = fpsManager.lagged() ? FlxColor.RED : FlxColor.WHITE;
	}

	var deltaTimeout:Float = .0;
	override function __enterFrame(deltaTime:Float):Void {
		if (!visible || flixel.FlxG.autoPause && !stage.nativeWindow.active) return;
		fpsManager.update(deltaTime);
		preUpdateText();

		deltaTimeout += deltaTime;
		if (deltaTimeout < 1000 / updateRate) return;

		updateText();
		deltaTimeout = 0.0;
	}

	public dynamic function updateText():Void {
		var newStr:String = '${fpsManager.curFPS}FPS';
		newStr += '\n' + FlxStringUtil.formatBytes(gcMEM) + ' / ' + FlxStringUtil.formatBytes(gcPeakMEM);

		if (newStr != lastText) {
			text = newStr;
			lastText = newStr;
		}
	}
}