package objects;

class Paper extends flixel.group.FlxSpriteContainer {
	var paper:FlxSprite;
	public var target:FlxSprite;

	var targetMouseOffset:FlxPoint = FlxPoint.get(24, 24);
	var paperMouseOffset:FlxPoint = FlxPoint.get(13, 39);
	var originalYOffset:Float = 0.0;

	public override function new() {
		super();

		add(target = new FlxSprite(Paths.image('play/target')));

		final PAPER_PATH:String = 'play/paper';
		paper = new FlxSprite(Paths.image(PAPER_PATH));
		paper.frames = Paths.sparrowAtlas(PAPER_PATH);
		paper.animation.addByPrefix('hit', 'hit', 24, false);
		paper.centerOffsets(true);

		paper.visible = false;
		originalYOffset = paper.offset.y;
		paper.animation.onFrameChange.add((name:String, num:Int, index:Int) -> paper.offset.y += 16);
		paper.animation.onFinish.add((_:String) -> {
			paper.offset.y = originalYOffset;
			paper.visible = false;
		});
		add(paper);
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);
		target.setPosition(FlxG.mouse.x - targetMouseOffset.x, FlxG.mouse.y - targetMouseOffset.y);

		if (FlxG.mouse.justPressed) {
			paper.setPosition(FlxG.mouse.x - paperMouseOffset.x, FlxG.mouse.y - paperMouseOffset.y);

			paper.offset.y = originalYOffset;
			paper.animation.play('hit', true);
			paper.visible = true;
		}
	}
}
