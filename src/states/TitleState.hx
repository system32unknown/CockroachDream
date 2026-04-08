package states;

import flixel.FlxG;
import flixel.FlxSprite;

class TitleState extends flixel.FlxState {
	override public function create() {
		super.create();

		var temp = Paths.image('bg');
		trace(temp);

		var bg:FlxSprite = new FlxSprite(temp);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.screenCenter();
		add(bg);
	}
}
