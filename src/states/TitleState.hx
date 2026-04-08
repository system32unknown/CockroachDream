package states;

import objects.Cockroach;

class TitleState extends flixel.FlxState {
	override public function create() {
		super.create();

		FlxG.mouse.visible = false;

		var bg:FlxSprite = new FlxSprite(Paths.image('bg'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.screenCenter();
		add(bg);

		var collision:FlxSprite = new FlxSprite(Paths.image('collision'));
		collision.alpha = 0;
		add(collision);

		var text:FlxText = new FlxText("Not yet done.");
		text.setFormat(16, LEFT);
		text.y = FlxG.height - text.height;
		add(text);

		var test:objects.Cockroach = new Cockroach(0, 0);
		test.appear();
		add(test);

		add(new objects.Paper());
	}
}
