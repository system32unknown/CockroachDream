package objects;

enum FaceState {
	Idle;
	Dead;
	Lev(level:Int);
}

class Face extends FlxSprite {
	var faceState:FaceState = Idle;
	var pat:Array<Int> = [];
	var cnt:Int = 0;
	var pn:Int = 0;
	var cntMax:Int = 3;

	public function new(x:Float, y:Float):Void {
		super(x, y);
		loadGraphic(Paths.image('play/face'), true, 100, 128);
		animation.add('face', [for (i in 0...frames.frames.length) i], 0, false);
		animation.play('face', true);
		updateHitbox();
		centerOrigin();

		setPatFrame(7);
	}

	public function gotoLev(level:Int):Void {
		cnt = 0;
		pn = 0;
		switch (level) {
			case 0:
				pat = [7, 7, 7, 7, 2, 7, 2, 7, 7, 7, 7, 7, 7, 7, 7, 7];
				cntMax = 3;
				faceState = Lev(0);
			case 1:
				pat = [8, 8, 8, 8, 7, 8, 7, 8, 8, 8, 8, 8, 7, 2, 8, 8];
				cntMax = 6;
				faceState = Lev(1);
			case 2:
				pat = [4, 4, 4, 4, 9, 5, 5, 5, 4, 4, 4, 2, 5, 5, 5, 5];
				cntMax = 3;
				faceState = Lev(2);
			case 3:
				pat = [7, 8, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 7, 3, 3, 4];
				cntMax = 3;
				faceState = Lev(3);
			case 4:
				pat = [3, 10, 11, 9, 3, 11, 10, 3, 9, 11, 3, 10, 9, 10, 3, 11];
				cntMax = 2;
				faceState = Lev(4);
			case 5:
				pat = [12, 5, 11, 4, 12, 5, 11, 4, 12, 5, 11, 4, 12, 5, 11, 4];
				cntMax = 1;
				faceState = Lev(5);
			case 6: gotoDead();
			default: gotoIdle();
		}
	}

	function gotoIdle():Void {
		faceState = Idle;
		pat = [];
		setPatFrame(7);
	}

	function gotoDead():Void {
		faceState = Dead;
		pat = [];
		setPatFrame(1);
	}

	function setPatFrame(frame:Int):Void {
		animation.frameIndex = frame - 1;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		switch (faceState) {
			case Idle | Dead:
			case Lev(_):
				setPatFrame(pat[pn]);
				cnt++;
				if (cnt >= cntMax) {
					cnt = 0;
					pn++;
					if (pn >= 16) pn = 0;
				}
		}
	}
}