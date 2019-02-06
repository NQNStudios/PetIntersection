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
import haxe.Timer;
import flixel.group.FlxGroup;
import CreditsState;
import flixel.system.FlxSound;

class PlayState extends FlxState
{
	var _typeText:FlxTypeText;
	var _story:Story;
	public var ingrid_sprite: FlxSprite;
	var prefix = '';
	public var background: FlxGroup;
	public var foreground: FlxGroup;
	var black_box: FlxSprite;
	var thought_bubble: FlxSprite;
	public var ape: FlxSprite;
	public var crossApe: FlxSprite;

	function revealText() {
		if (_typeText != null) {
			foreground.remove(_typeText);
			
		}

		var typeText = '';
		while (true) {
			var frame = _story.nextFrame();
			switch (frame) {
				case HasText(text):
					typeText += text+'\n';
				default:
					break;
			}
		}
		typeText = prefix + typeText;

		_typeText = new FlxTypeText(15, 500, FlxG.width - 30, typeText, 16, true);
		_typeText.delay = 0.01;
		_typeText.setTypingVariation(0.75, true);
		if (prefix == '') {
			_typeText.x += 10;
			_typeText.fieldWidth -= 40;
			// black text for thought bubble
			_typeText.color = 0x000000;
			playerVoiceSounds();
		} else {
			// white text for dialogue
			_typeText.color = 0xFFFFFF;

			switch (prefix) {
				case "you: ":
					playerVoiceSounds();
				default:
					_typeText.sounds = sounds[prefix];
					trace('${prefix}: ${_typeText.sounds}');
			}
		}
		
			if (_typeText.sounds.length == 0) _typeText.sounds = null;
		foreground.add(_typeText);
		_typeText.start(null, false, false, null, onComplete);
	}

	function playerVoiceSounds() {
		switch (playerSprite) {
				case "puppy":
					_typeText.sounds = sounds['plPuppy'];
				case "kitty":
					_typeText.sounds = sounds['plKitty'];
				case "kid":
					_typeText.sounds = sounds['plKid'];
			}
			if (_typeText.sounds.length == 0) _typeText.sounds = null;
		trace('SOUNDS');
			trace(_typeText.sounds);
	}

	public var playerSprite: String;
	var plSprites: Map<String, FlxSprite> = new Map();
	public var brownstone: FlxSprite;
	
	public function showPlayerSprite() {
		foreground.add(plSprites[playerSprite]);
	}

	var sounds: Map<String, Array<FlxSound>> = new Map();

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		black_box = new FlxSprite(0, 640-180);
		black_box.makeGraphic(960, 180, 0x000000);
		thought_bubble = new FlxSprite(0, 640-180);
		thought_bubble.loadGraphic('assets/images/thoughtbubble.jpg');
		ingrid_sprite = new FlxSprite(0, 0);
		ingrid_sprite.loadGraphic('assets/images/ingrid.jpg');
		brownstone = new FlxSprite(0, 0);
		brownstone.loadGraphic('assets/images/brownstone.jpg');
		brownstone.setGraphicSize(FlxG.width, FlxG.height);
		ape = new FlxSprite(450, 40);
		ape.loadGraphic('assets/images/the-ape.jpg');
		crossApe = new FlxSprite(450, 40);
		crossApe.loadGraphic('assets/images/cross-ape.jpg');

		plSprites['kid'] = new FlxSprite(20, 20);
		plSprites['kitty'] = new FlxSprite(20, 20);
		plSprites['puppy'] = new FlxSprite(20, 20);
		plSprites['kid'].loadGraphic('assets/images/plKid.jpg');
		plSprites['kitty'].loadGraphic('assets/images/plKitten.jpg');
		plSprites['puppy'].loadGraphic('assets/images/plPuppy.jpg');

		// Load sounds
		var ext='.wav';
		sounds['plKid'] = [ for (name in []) FlxG.sound.load('assets/audio/${name}${ext}') ];
		sounds['plKitty'] = [ for (name in []) FlxG.sound.load('assets/audio/${name}${ext}') ];
		trace(sounds['plKitty']);
		sounds['plPuppy'] = [ for (name in []) FlxG.sound.load('assets/audio/${name}${ext}') ];
		sounds['Ingrid: '] = [ for (name in ['ingrid1']) FlxG.sound.load('assets/audio/${name}${ext}') ];
		trace(sounds['Ingrid: '][0]);
		sounds['Ingrid: '][0].play();
		sounds['Roomie: '] = [ for (name in []) FlxG.sound.load('assets/audio/${name}${ext}') ];
		sounds['Old dog: '] = [ for (name in []) FlxG.sound.load('assets/audio/${name}${ext}') ];

#if debug
		_story = new Story(null, true);// Set the debug flag for the script skips
#else
		_story = new Story(null, false);
#end
		_story.loadScript("assets/scripts/main.hank");
		_story.addVariable("state", this);

		background = new FlxGroup();
		foreground = new FlxGroup();
		add(background);
		add(foreground);
		
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
				// reached the end of the story
				FlxG.switchState(new CreditsState());
		}
	}

	var choiceButtons: Array<FlxButtonPlus> = [];
	var callbacksMade = 0;
	var callbacksUsed = 0;
	function addChoiceButtons(choices: Array<String>) {
		var i = 0;
		var y = 580;
		trace('adding choice buttons when there are ${choiceButtons.length}');
		for (choice in choices) {
			choiceButtons.push(new FlxButtonPlus(0, y, onButtonChosen(i, callbacksMade++), choice, 300, 20));
			foreground.add(choiceButtons[i]);
			i++;
			y += 20;
		}
	}

	function clearChoiceButtons() {
		trace('clearing choice buttons');
		for (button in choiceButtons) {
			foreground.remove(button);
		}
		choiceButtons = [];
	}

	function onButtonChosen(idx: Int, id: Int) {
		// trace('generating callback #${id} for button ${idx}');
		return function() {
			if (id < callbacksUsed) return; // This avoids the inexplicable multiple choices bug
			// trace('calling callback #${id}');
			switch (_story.nextFrame())  {
				case HasChoices(choices):
					callbacksUsed += choices.length;
					// trace('calling choose(${idx}) between ${choices}');
					_story.choose(idx);
					clearChoiceButtons();
					revealText();
				default:
					// It's accidentally firing the button chosen event twice, which will cause a crash
			}
		};
		// TODO right now we're not displaying choices after clicking on them
	}

	public function dialogue(name: String) {
		if (name == 'thoughtbubble') {
			prefix = '';
			// remove black box, add thought bubble 
			trace('thought bubble add');
			foreground.remove(black_box);
			foreground.add(thought_bubble);
		}
		else {
			foreground.remove(thought_bubble);
			foreground.add(black_box);
			trace('black box add for ${name}');
			prefix = '${name}: ';

		}

	}
}

			// _typeText.sounds = [ FlxG.sound.load(FlxAssets.getSound("assets/type01")), FlxG.sound.load(FlxAssets.getSound("assets/type02")) ];