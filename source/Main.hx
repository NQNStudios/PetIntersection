package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		#if debug
		addChild(new FlxGame(960, 640, PlayState));
		#else 
		addChild(new FlxGame(960, 640, MenuState));
		#end
		// TODO set this to MenuState
	}
}