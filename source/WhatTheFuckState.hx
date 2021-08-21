package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;

class WhatTheFuckState extends FlxState
{
    var yourGod:FlxSprite;
    var tween:FlxTween;
    var trail:FlxTrail;

    override public function create()
    {
        yourGod = new FlxSprite().loadGraphic(Paths.image('pauseAlt/yourGod/errorUNFOUND'));
        yourGod.screenCenter(Y);
        yourGod.x = FlxG.width / 2 - yourGod.width;
        yourGod.alpha = 0;
        yourGod.setGraphicSize(Std.int(yourGod.width * 2));
        add(yourGod);
        
        tween = FlxTween.tween(yourGod, {x: yourGod.x + 125}, 0.1, {ease: FlxEase.quadInOut, type: PINGPONG});
        FlxTween.tween(yourGod, {alpha: 0.25}, 1, {ease: FlxEase.circOut});
        
        trail = new FlxTrail(yourGod, null, 4, 24, 0.3, 0.069);
        add(trail); 

        FlxG.sound.playMusic(Paths.music('errorerrorunknownhelppleaseithasmeitscominghelpohgodihearitinthehallsorinmyheadohgodohpleasesomone'));
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        new FlxTimer().start(10, function(tmr:FlxTimer)
        {
            yourGod.screenCenter();
            yourGod.setGraphicSize(Std.int(yourGod.width * 3));

            tween.cancel();

            remove(trail);

            FlxG.sound.music.stop();
        }); 

        new FlxTimer().start(20, function(tmr:FlxTimer)
        {
            FlxG.switchState(new PlayState());
        });
    }
}