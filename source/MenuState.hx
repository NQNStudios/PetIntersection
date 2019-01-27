package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState {
    public override function create() {
        add(new FlxText(0, 0, "Pet Intersection"));
        add(new FlxText(0, 20, "--Hell is Other Animals--"));
        add(new FlxButton(0, 40, "Play", playClicked));
        add(new FlxButton(0, 60, "Credits", creditsClicked));
    }

    function playClicked() {
        FlxG.switchState(new PlayState());
    }
    function creditsClicked() {
        FlxG.switchState(new CreditsState());
    }
}