package backend;

@:structInit
@:publicFields
class SaveVariables {
	var antialiasing:Bool = true;
	var framerate:Int = 60;
    var autoPause:Bool = true;
    var autoCleanAssets:Bool = true;

	// Miscellaneous
	var showFPS:Bool = true;
	var memCounterType:String = 'GC';

	var cheatSettings:Map<String, Dynamic> = [
		'botplay' => false,
		'noStress' => false,
	];
}

class Settings {
	public static final default_data:SaveVariables = {};
	public static var data:SaveVariables = {};

	public static function save() {
		for (key in Reflect.fields(data)) {
			// ignores variables with getters
			if (Reflect.hasField(data, 'get_$key')) continue;
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));
		}
		FlxG.save.flush();
	}

	public static function load() {
		FlxG.save.bind('settings', Util.getSavePath());

		final fields:Array<String> = Type.getInstanceFields(SaveVariables);
		for (setting in Reflect.fields(FlxG.save.data)) {
			if (setting == 'cheatSettings' || !fields.contains(setting)) continue;

			var dataField:Dynamic = Reflect.field(FlxG.save.data, setting);
			if (Reflect.hasField(data, 'set_$setting')) Reflect.setProperty(data, setting, dataField);
			else Reflect.setField(data, setting, dataField);
		}
		if (FlxG.save.data.cheatSettings != null) {
			final map:Map<String, Dynamic> = FlxG.save.data.cheatSettings;
			for (name => value in map) data.cheatSettings.set(name, value);
		}

		if (Main.fpsVar != null) {
			Main.fpsVar.visible = data.showFPS;
			Main.fpsVar.memDisplay = data.memCounterType;
		}
		FlxG.autoPause = data.autoPause;

		if (FlxG.save.data.framerate == null) data.framerate = Std.int(FlxMath.bound(FlxG.stage.application.window.displayMode.refreshRate * 2, 60, 240));
		Util.changeFramerateCap(data.framerate);

		// flixel automatically saves your volume!
		if (FlxG.save.data.volume != null) FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null) FlxG.sound.muted = FlxG.save.data.mute;
	}

	public static inline function reset():Void {
		data = default_data;
	}

	inline public static function getCheatSetting(name:String, defaultValue:Dynamic = null):Dynamic {
		defaultValue = default_data.cheatSettings[name];
		return (data.cheatSettings.exists(name) ? data.cheatSettings[name] : defaultValue);
	}
}