package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxState;

class ControlsSubState 
{
	private var grpSongs:FlxTypedGroup<Alphabet>;
	var control:FlxText;
	var lol:Int = 0;

	public function create()
	{

		// control = new FlxText(20, 0, "WASD", 35);
		// control.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		// control.scrollFactor.set();
		// control.x = FlxG.width / 2 + 30;
		// control.y += 30;
		// add(control);
			
	}
	public function update(elapsed:Float)
	{
	// 	if (FlxG.mouse.overlaps(control))
	// 	{
	// 		if (FlxG.mouse.pressed && lol == 0)
	// 		{
	// 			lol = 1;
	// 			control.text = "DFJK";
	// 		}
	// 		else if (FlxG.mouse.pressed && lol == 1)
	// 		{
	// 			lol = 0;
	// 			control.text = "WASD";
	// 		}
	// 	}
	// }
	}
}
