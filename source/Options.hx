package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();
	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	
	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";
	public final function getName() {
		return _name;
	}

	public function new (catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}
	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;
	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	public function getValue():String { return throw "stub!"; };
	
	// Returns whether the label is to be updated.
	public function press():Bool { return throw "stub!"; }
	private function updateDisplay():String { return throw "stub!"; }
	public function left():Bool { return throw "stub!"; }
	public function right():Bool { return throw "stub!"; }
}

class DFJKOption extends Option
{
	private var controls:Controls;

	public function new(controls:Controls)
	{
		super();
		this.controls = controls;
	}

	public override function press():Bool
	{
		FlxG.switchState(new KeyBindMenu());
		return false;
	}

	private override function updateDisplay():String
	{
		return "Key Bindings";
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.downscroll ? "Downscroll" : "Upscroll";
	}
}

class GhostTapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.newInput ? "Cleaner inputs" : "Harsher Inputs";
	}
}

class Counters extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.dontShowCounters = !FlxG.save.data.dontShowCounters;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.dontShowCounters ? "Do Not Show Counters" : "Show Counters";
	}
}

class NoteEffects extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.dontShowNoteEffect = !FlxG.save.data.dontShowNoteEffect;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.dontShowNoteEffect ? "Do Not Show Note Effect" : "Show Note Effect";
	}
}

class MiddleScroll extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.middleScroll ? "Middle Scroll On" : "Middle Scroll Off";
	}
}

class MiddleScrollBox extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Middle Scroll Box Alpha: ";
	}
	
	override function right():Bool {
		if (FlxG.save.data.middleScrollBox >= 1)
		{
			FlxG.save.data.middleScrollBox = 0;
		}
		else
			FlxG.save.data.middleScrollBox = FlxG.save.data.middleScrollBox + 0.1;

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.middleScrollBox > 1)
			FlxG.save.data.middleScrollBox = 0;
		else if (FlxG.save.data.middleScrollBox < 0) // && FlxG.save.data.middleScrollBox != -1
			FlxG.save.data.middleScrollBox = 1;
		else
			FlxG.save.data.middleScrollBox = FlxG.save.data.middleScrollBox - 0.1;
		return true;
	}

	override function getValue():String
	{
		return "Middle Scroll Box Alpha: " + FlxG.save.data.middleScrollBox;
	}
}

class FPSCapOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
	
	override function right():Bool {
		if (FlxG.save.data.fpsCap >= 290)
		{
			FlxG.save.data.fpsCap = 290;
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
		}
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.fpsCap > 290)
			FlxG.save.data.fpsCap = 290;
		else if (FlxG.save.data.fpsCap < 60)
			FlxG.save.data.fpsCap = Application.current.window.displayMode.refreshRate;
		else
			FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
		return true;
	}

	override function getValue():String
	{
		return "Current FPS Cap: " + FlxG.save.data.fpsCap + 
		(FlxG.save.data.fpsCap == Application.current.window.displayMode.refreshRate ? "Hz (Refresh Rate)" : "");
	}
}

class Hitsound extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.playHitsound = !FlxG.save.data.playHitsound;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.playHitsound ? "Play Hitsound Upon Tap" : "Dont Play Hitsound";
	}
}

class GoToGit extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.openURL('https://github.com/Kayyo321/Lyme-Engine-Master');
		return false;
	}

	private override function updateDisplay():String
	{
		return "github repository";
	}
}

class GoToBanana extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.openURL('https://gamebanana.com/mods/312257');
		return false;
	}

	private override function updateDisplay():String
	{
		return "game banana page";
	}
}

class BlueNotes extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.blueNote = !FlxG.save.data.blueNote;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.blueNote ? "Notes Dark Theme" : "Notes Default Theme";
	}
}

class Icons extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.iconsOff = !FlxG.save.data.iconsOff;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.iconsOff ? "Health Icons Off" : "Health Icons On";
	}
}

class Bar extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.healthBarOff = !FlxG.save.data.healthBarOff;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.healthBarOff ? "HealthBar Off" : "HealthBar On";
	}
}

class CountersAlpha extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		acceptValues = true;
	}

	public override function press():Bool
	{
		return false;
	}

	private override function updateDisplay():String
	{
		return "Counters Transparancy ";
	}
	
	override function right():Bool {
		if (FlxG.save.data.countersAlpha > 1)
		{
			FlxG.save.data.countersAlpha = 1;
		}
		else
			FlxG.save.data.countersAlpha = FlxG.save.data.countersAlpha + 0.1;

		return true;
	}

	override function left():Bool {
		if (FlxG.save.data.countersAlpha > 1)
			FlxG.save.data.countersAlpha = 1;
		else if (FlxG.save.data.countersAlpha < 0.3) 
			FlxG.save.data.countersAlpha = 0.3;
		else
			FlxG.save.data.countersAlpha = FlxG.save.data.countersAlpha - 0.1;
		return true;
	}

	override function getValue():String
	{
		return "Counters Transparancy " + FlxG.save.data.countersAlpha;
	}
}

class StepMainia extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.stepMainia = !FlxG.save.data.stepMainia;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.stepMainia ? "Step Mainia Notes" : "Default Notes";
	}
}

class CoolMenu extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
	}

	public override function press():Bool
	{
		FlxG.save.data.menu = !FlxG.save.data.menu;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return FlxG.save.data.menu ? "Horizontal Menu Layout" : "Vertical  Menu Layout";
	}
}