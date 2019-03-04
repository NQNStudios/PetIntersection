package;

import haxe.Json;
import haxe.Http;
import haxe.io.Bytes;
import flash.display.BitmapData;
import flixel.FlxSprite;

class Unsplash {
    static var rootUrl = 'https://api.unsplash.com/';
    var apiKey: String;

    public function new(apiKey: String) {
        this.apiKey = apiKey;
    }

    public function sprite(query: String, x: Int, y: Int, width: Int, height: Int): FlxSprite {
        var url =  '${rootUrl}photos/random?query=${query}&client_id=${this.apiKey}';
        var json = Http.requestUrl(url);
        trace(json);
        var possibleImages:Dynamic = Json.parse(json);
        trace('poss: ${possibleImages}');
        
        var imageUrl = '${possibleImages.urls.full}&w=${width}&h=${height}';
        trace('image url: ${imageUrl}');
        var bytes = Bytes.ofString(Http.requestUrl(imageUrl));
        var sprite = new FlxSprite(x, y);
        sprite.loadGraphic(BitmapData.fromBytes(bytes));
        return sprite;
    }
}