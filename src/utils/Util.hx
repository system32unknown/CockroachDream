package utils;

class Util {
	public static function addFileExtension(string:String, extension:String):String {
		if (string.lastIndexOf('.') >= 0) return string;
		return string += '.$extension';
	}

	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		return '${FlxG.stage.application.meta.get('company')}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
	}

	inline public static function changeFramerateCap(newFramerate:Int):Void {
		if (newFramerate > FlxG.updateFramerate) {
			FlxG.updateFramerate = newFramerate;
			FlxG.drawFramerate = newFramerate;
		} else {
			FlxG.drawFramerate = newFramerate;
			FlxG.updateFramerate = newFramerate;
		}
	}
}
