package;

#if DEBUG_TRACY
import cpp.vm.tracy.TracyProfiler;
import openfl.events.Event;
#end

@:nullSafety
class Init extends flixel.FlxState {
	/**
	 * Simply states whether the "core stuff" is ready or not.
	 * This is used to prevent re-initialization of specific core features.
	 */
	@:noCompletion
	static var _coreInitialized:Bool = false;

	override function create():Void {
		setup();
		FlxG.switchState(Main.game.initialState);
	}

	/**
	 * Setup a bunch of important Flixel stuff.
	 */
	function setup():Void {
		if (!_coreInitialized) {
			#if cpp untyped __cpp__("setbuf(stdout, 0)"); #end

			#if DEBUG_TRACY
			FlxG.stage.addEventListener(Event.EXIT_FRAME, (e:Event) -> TracyProfiler.frameMark());
			TracyProfiler.setThreadName("main");
			#end

			FlxG.fixedTimestep = false;
			FlxG.game.focusLostFramerate = 60;
			FlxG.keys.preventDefaultKeys = [TAB];
			FlxG.cameras.useBufferLocking = true;
			FlxG.inputs.resetOnStateSwitch = false;

			#if CRASH_HANDLER debug.CrashHandler.init(); #end
			_coreInitialized = true;
		}

		Paths.clearStoredMemory();
	}
}