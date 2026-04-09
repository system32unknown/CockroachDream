package objects;

class Face extends flixel.FlxSprite {
	override public function new(x:Float, y:Float) {
		super(x, y);
		loadGraphic(Paths.image("face"));
	}
}