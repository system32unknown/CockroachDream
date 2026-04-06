package;

import flixel.FlxG;
import flixel.FlxSprite;

class TitleState extends flixel.FlxState {
	override public function create() {
		super.create();

		var bg:FlxSprite = new FlxSprite(AssetPaths.bg__png);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.screenCenter();
		add(bg);
	}
}
