package scenes;

import h2d.Interactive;
import haxe.display.Display.Package;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Scene;
import data.Events;
import data.Player;

class Dialogue implements Level {
    public var scene: Scene;
    public var textbox: Bitmap;
    public var option1: Interactive;
    public var option2: Interactive;
    public var event: Map<String, Dynamic>; // did i do this right?
    public var player: Player;

    public function new(eventsData: Events, playerData: Player) {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);
        var scenario = Math.floor(Math.random() * eventsData.events.length); // just random picking for now, might need to add logic based on flags
        event = eventsData.events[scenario];
        eventsData.events.remove(scenario); // remove the encountered event from the list
        player = playerData;
    }

    public function init(): Void {
        // Init textbox
        textbox = new Bitmap(hxd.Res.img.textbox.toTile(), scene)); // needs james textbox
        var font : h2d.Font = hxd.res.DefaultFont.get();

        // Init text
        var main = new h2d.Text(font);
        main.text = event.get("main");
        textbox.addChild(main);

        var opt1 = new h2d.Text(font);
        opt1.text = event.get("opt1").get("text");
        option1 = new h2d.Interactive(300, 100, opt1); // need to change size
        textbox.addChild(opt1); // and placement

        var opt2 = new h2d.Text(font);
        opt2.text = event.get("opt2").get("text");
        option2 = new h2d.Interactive(300, 100, opt2);
        textbox.addChild(opt2);
    
    }

    public function update(dt: Float): Null<Level> {
        option1.onClick = function(event : hxd.Event) {
            var flags = player.flags;
            for (String flag : event.get("opt1").get("consequences").keyset()) {
                if (flags.keyset.contains(flag)) {
                    flags.put(flag, flags.get(flag) + event.get("opt1").get("consequences").get(flag));
                } else {
                    flags.put(flag, 1);
                }
            }
        }
        option2.onClick = function(event : hxd.Event) {
            var flags = player.flags;
            for (String flag : event.get("opt2").get("consequences").keyset()) {
                if (flags.keyset.contains(flag)) {
                    flags.put(flag, flags.get(flag) + event.get("opt2").get("consequences").get(flag));
                } else {
                    flags.put(flag, 1);
                }
            }
        }
        return null;
    }


}