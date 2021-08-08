package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Charting State', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var diff:String = "";

	var canMove:Bool = true;

	public function new(x:Float, y:Float)
	{
		super();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		// menuItems.alpha = 0;

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		if (PlayState.storyDifficulty == 0)
			diff = "Easy";
		else if (PlayState.storyDifficulty == 1)
			diff = "Normal";
		else if (PlayState.storyDifficulty == 2)
			diff = "Hard";

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (canMove)
		{
			if (upP)
			{
				changeSelection(-1);
			}
			if (downP)
			{
				changeSelection(1);
			}
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			if (canMove)
			{
				switch (daSelected)
				{
					case "Resume":
							var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ready'));
							ready.scrollFactor.set();
							ready.updateHitbox();
							ready.screenCenter();

							var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image('set'));
							set.scrollFactor.set();
							set.updateHitbox();
							set.screenCenter();

							var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image('go'));
							go.scrollFactor.set();
							go.updateHitbox();
							go.screenCenter();

							canMove = false;

							var startTimer:FlxTimer = new FlxTimer().start(0.3, function(tmr:FlxTimer)
							{
								
								FlxG.sound.play(Paths.sound('intro3'));

								var startTimer:FlxTimer = new FlxTimer().start(0.3, function(tmr:FlxTimer)
								{
									add(ready);
									FlxG.sound.play(Paths.sound('intro2'));

									var startTimer:FlxTimer = new FlxTimer().start(0.3, function(tmr:FlxTimer)
									{
										remove(ready);
										add(set);

										FlxG.sound.play(Paths.sound('intro1'));

										var startTimer:FlxTimer = new FlxTimer().start(0.3, function(tmr:FlxTimer)
										{
											remove(set);
											add(go);
											FlxG.sound.play(Paths.sound('introGo'));
											var startTimer:FlxTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer)
											{
												remove(go);
												close();
											});
										});
									});	
								});
							});
					// im so sorry for so many timers DX
					case "Restart Song":
						if (canMove)
							FlxG.resetState();
						else 
							trace("can't reset state yet, you're unpausing!");
					case "Charting State":
						if (canMove) 
							FlxG.switchState(new ChartingState());
					case "Exit to menu":
						if (canMove)
							FlxG.switchState(new MainMenuState());
						else 
							trace("can't go to menu, you're unpausing!");	
				}
				// I triple check it cuz I rly don't wanna crash XD
			}
		}

		if (FlxG.keys.justPressed.J)
		{
			// for reference later!
			// PlayerSettings.player1.controls.replaceBinding(Control.LEFT, Keys, FlxKey.J, null);
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
