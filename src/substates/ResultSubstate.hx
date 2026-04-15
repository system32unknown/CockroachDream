package substates;

import flixel.ui.FlxButton;

class ResultSubstate extends flixel.FlxSubState {
	var gameover:FlxSprite;
	var congratulations:FlxSprite;

	public var isVictory:Bool = false;

	override function create() {
		super.create();

		gameover = new FlxSprite(Paths.image('ui/gameover'));
		gameover.visible = false;
		gameover.gameCenter();
		add(gameover);

		congratulations = new FlxSprite(Paths.image('ui/congratulations'));
		congratulations.visible = false;
		congratulations.gameCenter();
		add(congratulations);

		var firstSprY:Float = 0.0;
		if (isVictory) {
			congratulations.visible = true;
			firstSprY = congratulations.height + congratulations.y;
		} else {
			gameover.visible = true;
			firstSprY = gameover.height + gameover.y;
		}

		var retryBtn:FlxButton = new FlxButton(0, firstSprY + 20, "Retry", () -> {
			closeSubState();
			FlxG.resetState();
		});
		retryBtn.gameCenter(X);
		add(retryBtn);
	}
}