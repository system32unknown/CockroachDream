package utils;

import flixel.FlxG;

class FPSUtil {
	@:noCompletion var times:Array<Int>;
	@:noCompletion var sum:Int;
	@:noCompletion var sliceCnt:Int;

	/**
	 * The current frame rate, expressed using frames-per-second.
	 */
	public var curFPS(default, null):Int;

	/**
	 * The total accumulated frame rate, potentially used for averaging over time.
	 */
	public var totalFPS(default, null):Int;

	/**
	 * The raw frame rate over a short period.
	 */
	public var avgFPS(default, null):Float;

	public var clampFPS:Bool = true;

	/**
	 * Internal counter used for frame rate calculations or caching.
	 */
	var cacheCount:Int;

	public function new():Void {
		curFPS = 0;
		avgFPS = 0;
		sum = sliceCnt = 0;
		times = [];
	}

	/**
	 * Updates the FPS calculations based on the given delta time.
	 */
	public function update(dt:Float):Void {
		sliceCnt = 0;
		var delta:Int = Math.round(dt);
		times.push(delta);
		sum += delta;

		while (sum > 1000) {
			sum -= times[sliceCnt];
			++sliceCnt;
		}
		if (sliceCnt > 0) times.splice(0, sliceCnt);

		var curCount:Int = times.length;
		totalFPS = Std.int(curFPS + curCount / 8);
		if (curCount != cacheCount) {
			avgFPS = curCount > 0 ? 1000 / (sum / curCount) : 0.0;
			var roundAvgFPS:Int = Math.round(avgFPS);
			curFPS = clampFPS ? (roundAvgFPS < FlxG.drawFramerate ? roundAvgFPS : FlxG.drawFramerate) : roundAvgFPS;
		}
		cacheCount = curCount;
	}

	/**
	 * Adjusts the value based on the reference FPS.
	 */
	public static inline function fpsAdjust(value:Float, ?referenceFps:Float = 60):Float {
		return value * (referenceFps * FlxG.elapsed);
	}

	public function lagged():Bool {
		return curFPS < FlxG.drawFramerate * .5;
	}
}