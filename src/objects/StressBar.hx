package objects;

import flixel.ui.FlxBar;

class StressBar extends FlxSpriteGroup {
	public var bar:FlxBar;
	public var bg:FlxSprite;

	override public function new(x:Float, y:Float) {
		super(x, y);

		bar = new FlxBar(73, 0, LEFT_TO_RIGHT, 555, 9, null, "", 0, 800);
		bar.createGradientFilledBar([FlxColor.RED, FlxColor.YELLOW]);
		bar.createColoredEmptyBar(FlxColor.TRANSPARENT);
		bar.numDivisions = 400;
		add(bar);

		bg = new FlxSprite(Paths.image('ui/bar'));
		bg.gameCenter(X);
		add(bg);
	}
}