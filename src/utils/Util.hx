package utils;

class Util {
	public static function addFileExtension(string:String, extension:String):String {
		if (string.lastIndexOf('.') >= 0) return string;
		return string += '.$extension';
	}
}