package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import PlayState;

class CreditsState extends FlxState {
    public override function create() {
        add(new FlxText(0, 0, "Written and programmed by Nat Quayle Nelson"));
        add(new FlxText(0, 20, "Voice Talent: Joshua Hedges")); // TODO voice talent
        add(new FlxText(0, 40, "Some photos & images used are public domain, others are original"));
        add(new FlxText(0, 60, "Bankers lamp image https://thebankerslamp.com/history-original-bankers-lamp/"));
        add(new FlxButton(0, 80, "Play", playClicked));
    }

    function playClicked() {
        FlxG.switchState(new PlayState());
    }
}