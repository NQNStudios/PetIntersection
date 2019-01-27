package;

import flixel.graphics.tile.FlxDrawQuadsItem;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import hank.Story;

class PlayState extends FlxState
{
	var _typeText:FlxTypeText;
	var _story:Story;
	public var ingrid_sprite: FlxSprite;
	var prefix = '';

	function revealText() {
		if (_typeText != null) {
			remove(_typeText);
		}

		var typeText = prefix;
		while (true) {
			var frame = _story.nextFrame();
			switch (frame) {
				case HasText(text):
					typeText += text+'\n';
				default:
					break;
			}
		}
		_typeText = new FlxTypeText(15, 500, FlxG.width - 30, typeText, 16, true);
		_typeText.delay = 0.01;
		_typeText.setTypingVariation(0.75, true);
		
		add(_typeText);
		_typeText.start(onComplete);
	}
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		ingrid_sprite = new FlxSprite(0, 0);
		ingrid_sprite.loadGraphic('assets/images/ingrid.jpg', false);

		_story = new Story();
		_story.loadScript("assets/scripts/main.hank");
		_story.addVariable("state", this);
		
		revealText();
		
		super.create();
	}
	
	function onComplete():Void
	{
		// TODO display the choices that come next as buttons
		var frame = _story.nextFrame();
		switch (frame) {
			case HasChoices(choices):
				addChoiceButtons(choices);
			default:
				add(new FlxText(0, 0, 'fuuuuuuck you'));
		}
	}

	var choiceButtons: Array<FlxButtonPlus> = [];
	function addChoiceButtons(choices: Array<String>) {
		var i = 0;
		var y = 580;
		trace('adding choice buttons when there are ${choiceButtons.length}');
		for (choice in choices) {
			choiceButtons.push(new FlxButtonPlus(0, y, onButtonChosen(i), choice, 300, 20));
			add(choiceButtons[i]);
			i++;
			y += 20;
		}
	}

	function clearChoiceButtons() {
		for (button in choiceButtons) {
			remove(button);
		}
		choiceButtons = [];
	}

	function onButtonChosen(idx: Int) {
		trace('generating a callback for button ${idx}');
		return function() {
			switch (_story.nextFrame()) {
				case HasChoices(choices):
					trace('calling choose(${idx}) between ${choices}');
					_story.choose(idx); clearChoiceButtons(); revealText();
				default:
					// It's accidentally firing the button chosen event twice, which will cause a crash
			}
		};
		// TODO right now we're not displaying choices after clicking on them
	}

	public function dialogue(name: String) {
		prefix = '${name}: ';

		// TODO add (and remove the old one) a black box along the bottom at 0, 500, FlxG.width, 140

		// TODO assign its sounds based on who's talking
		// _typeText.sounds = [ FlxG.sound.load(FlxAssets.getSound("assets/type01")), FlxG.sound.load(FlxAssets.getSound("assets/type02")) ];

	}
}