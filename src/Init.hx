package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;

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

			// Diamond Transition setup
			var diamond:FlxGraphic = FlxGraphic.fromClass(flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			// Reusable function
			function updateTransitions():Void {
				var defaultData:TransitionData = new TransitionData(FADE, FlxColor.BLACK, .7, FlxPoint.get(), {asset: diamond, width: 32, height: 32});
				FlxTransitionableState.defaultTransIn = defaultData;
				FlxTransitionableState.defaultTransOut = defaultData;
			}

			// Initial setup
			updateTransitions();
			Settings.load();

			// Handle resize
			FlxG.signals.gameResized.add((_, _) -> updateTransitions());

			#if CRASH_HANDLER debug.CrashHandler.init(); #end
			_coreInitialized = true;
		}

		Paths.clearStoredMemory();
	}
}