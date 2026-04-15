package substates;

import ui.PsychUIEventHandler.PsychUIEvent;

class OptionSubstate extends flixel.FlxSubState implements PsychUIEvent {
    var fpsStepper:PsychUINumericStepper;

    override function create() {
        super.create();

        var optBox:PsychUIBox;
		optBox = new PsychUIBox(0, 0, 220, 220, ['Options']);
		optBox.scrollFactor.set();
		add(optBox);

        var tab_group:FlxSpriteGroup = optBox.getTab('Options').menu;
        var objY:Float = 20;
        fpsStepper = new PsychUINumericStepper(10, objY, 1, 120, 30, 120);
        tab_group.add(new FlxText(fpsStepper.x, fpsStepper.y - 15, 100, 'FPS:'));
        tab_group.add(fpsStepper);

        fpsStepper.value = Settings.data.framerate;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ESCAPE) close();
    }

    public function UIEvent(id:String, sender:Dynamic) {}
}