package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import PlayState;

class CreditsState extends FlxState {
    public override function create() {
        add(new FlxText(0, 0, "Written and programmed by Nat Quayle Nelson"));
        add(new FlxText(0, 20, "Voice Talent: ")); // TODO voice talent
        add(new FlxButton(0, 40, "Play", playClicked));
    }

    function playClicked() {
        FlxG.switchState(new PlayState());
    }
}