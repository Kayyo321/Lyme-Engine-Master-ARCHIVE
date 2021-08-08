package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

/**
	*DEBUG MODE
 */
class AnimationDebug extends FlxState
{
	var bf:Boyfriend;
	var dad:Character;
	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var grabbed:Bool;
	var newDummy:FlxSprite;
	var isDad:Bool = true;
	var dummy:FlxSprite;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;

	var dummyChar:FlxSprite;

	var backspace:FlxSprite;
	var hideInstructionsLOL:FlxText;
	var moveBarLOL:FlxText;
	var hideLOL:FlxText;
	var bfAnimsLOL:FlxText;
	var instructionsLOL:FlxText;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(20, 20);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else
		{
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.debugMode = true;
			add(bf);

			char = bf;
			bf.flipX = false;
		}

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.mouse.visible = true;
		FlxG.camera.follow(camFollow);

		instructionsLOL = new FlxText(FlxG.width / 2, 20, 0, "WASD (space to play idle) to play each animation (N & M to scroll through)", 12);
		instructionsLOL.color = FlxColor.BLUE;
		if (!isDad)
			instructionsLOL.y -= 15;
		instructionsLOL.scrollFactor.set();
		add(instructionsLOL);

		bfAnimsLOL = new FlxText(FlxG.width / 2, 35, 0, "IKJL to play miss animations", 12);
		bfAnimsLOL.color = FlxColor.BLUE;
		bfAnimsLOL.scrollFactor.set();
		if (!isDad)
			add(bfAnimsLOL);

		hideLOL = new FlxText(FlxG.width / 2, 35, 0, "press H / B to show frame height / width", 12);
		hideLOL.color = FlxColor.BLUE;
		hideLOL.scrollFactor.set();
		if (!isDad)
			hideLOL.x += 10;
		add(hideLOL);

		moveBarLOL = new FlxText(FlxG.width / 2, 50, 0, "hold left mouse button to move the position bar", 12);
		moveBarLOL.color = FlxColor.BLUE;
		moveBarLOL.scrollFactor.set();
		if (!isDad)
			moveBarLOL.x += 10;
		add(moveBarLOL);

		backspace = new FlxSprite(FlxG.width - 350, 100);
		backspace.frames = Paths.getSparrowAtlas('backspace');
		backspace.animation.addByPrefix('blue', 'backspace PRESSED', 24);
		add(backspace);

		dummy = new FlxSprite(FlxG.width / 2, FlxG.height / 2).makeGraphic(500, 10, FlxColor.BLACK);
		dummy.alpha = 0.6;
		add(dummy);

		newDummy = new FlxSprite(char.x, char.y).makeGraphic(char.frameWidth, char.frameHeight, FlxColor.BLACK);
		newDummy.alpha = 0.3;
		newDummy.visible = false;
		add(newDummy);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.justPressed.E)
			FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q)
			FlxG.camera.zoom -= 0.25;

		camFollow.velocity.set();

		if (FlxG.keys.justPressed.N)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.M)
		{
			curAnim += 1;
		}


		if (FlxG.keys.justPressed.H)
		{
			dummy.visible = false;
			newDummy.visible = true;
		}
		else if (FlxG.keys.justPressed.B)
		{
			dummy.visible = true;
			newDummy.visible = false;
		}

		if (isDad)
		{
			if (FlxG.keys.justPressed.W)
				dad.playAnim('singUP');
			else if (FlxG.keys.justPressed.S)
				dad.playAnim('singDOWN');
			else if (FlxG.keys.justPressed.A)
				dad.playAnim('singLEFT');
			else if (FlxG.keys.justPressed.D)
				dad.playAnim('singRIGHT');
		}
		else if (!isDad)
		{
			if (FlxG.keys.justPressed.W)
				bf.playAnim('singUP');
			else if (FlxG.keys.justPressed.S)
				bf.playAnim('singDOWN');
			else if (FlxG.keys.justPressed.A)
				bf.playAnim('singLEFT');
			else if (FlxG.keys.justPressed.D)
				bf.playAnim('singRIGHT');
			else if (FlxG.keys.justPressed.I)
				bf.playAnim('singUPmiss');
			else if (FlxG.keys.justPressed.K)
				bf.playAnim('singDOWNmiss');
			else if (FlxG.keys.justPressed.J)
				bf.playAnim('singLEFTmiss');
			else if (FlxG.keys.justPressed.L)
				bf.playAnim('singRIGHTmiss');
		} // wsad for normal note anim's, ikjl for miss animations, that's why its only for bf XD

		if (FlxG.mouse.justPressed || FlxG.mouse.pressed)
		{
			dummy.x = FlxG.mouse.x - 150;
			dummy.y = FlxG.mouse.y;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.M || FlxG.keys.justPressed.N || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim]);

			updateTexts();
			genBoyOffsets(false);
		}

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			black.alpha = 0;
			add(black);

			new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				black.alpha += 0.15;
				if (black.alpha != 1)
					tmr.reset();
				else 
					FlxG.switchState(new PlayState());
			});
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		super.update(elapsed);
	}
}
