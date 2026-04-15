package states;

import flixel.ui.FlxButton;
import flixel.graphics.FlxGraphic;

class TitleState extends flixel.addons.transition.FlxTransitionableState {
	override public function create():Void {
		super.create();

		if (FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music('title'), null, 0);
			FlxG.sound.music.fadeIn();
		}

		var bg:FlxSprite = new FlxSprite(Paths.image('bg'));
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.gameCenter();
		add(bg);

		var title:FlxSprite = new FlxSprite(Paths.image('title/title'));
		title.gameCenter(X).y = 40;
		add(title);

		var click1:FlxGraphic = Paths.image('title/click1');
		var click2:FlxGraphic = Paths.image('title/click2');

		var clickBtn:FlxButton = new FlxButton(280, 264, "", () -> FlxG.switchState(() -> new PlayState()));
		clickBtn.loadGraphic(click1);
		clickBtn.onOver.callback = () -> clickBtn.loadGraphic(click2);
		clickBtn.onOut.callback = () -> clickBtn.loadGraphic(click1);
		clickBtn.gameCenter(X);
		add(clickBtn);

		var clickOpt:FlxButton = new FlxButton(280, clickBtn.y + 20, "Options", () -> openSubState(new substates.OptionSubstate()));
		clickOpt.gameCenter(X);
		add(clickOpt);
	}
}
