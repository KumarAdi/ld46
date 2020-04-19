package scenes;

import h2d.Interactive;
import haxe.display.Display.Package;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Scene;
import data.Events;
import data.Player;
import hxd.Res;

class Dialogue implements Level {
    public var scene: Scene;
    public var textbox: Bitmap;
    public var option1: Interactive;
    public var option2: Interactive;
    public var event: Event;
    public var player: Player;

    public function new(events: Events, player: Player) {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);
        var scenario = Math.floor(Math.random() * events.events.length); // just random picking for now, might need to add logic based on flags
        event = events.events[scenario];
        events.events.remove(event); // remove the encountered event from the list
        this.player = player;
    }

    public function init(): Void {
        // Init textbox
        textbox = new Bitmap(Tile.fromColor(0x000000, 500, 300), scene);
        textbox.x = 1920/2 - 250;
        textbox.y = 1080/2 - 150;
        // new Bitmap(Res.img.textbox.toTile(), scene); // needs james textbox
        var font : h2d.Font = hxd.res.DefaultFont.get();

        // Init text
        var main = new h2d.Text(font);
        main.text = event.main;
        main.textColor = 0xFFFFFF;
        textbox.addChild(main);

        var opt1 = new h2d.Text(font);
        opt1.text = event.opt1.text;
        option1 = new h2d.Interactive(300, 100, opt1); // need to change size
        opt1.textColor = 0xFFFFFF;
        opt1.y = 100;
        textbox.addChild(opt1); // and placement

        var opt2 = new h2d.Text(font);
        opt2.text = event.opt2.text;
        option2 = new h2d.Interactive(300, 100, opt2);
        opt2.textColor = 0xFFFFFF;
        opt2.y = 150;
        textbox.addChild(opt2);
    
    }

    public function update(dt: Float): Null<Level> {
        // TODO: these should probably be moved to init before being uncommented

        // option1.onClick = function(event : hxd.Event) {
        //     var flags = player.flags;
        //     for (String flag : event.get("opt1").get("consequences").keyset()) {
        //         if (flags.keyset.contains(flag)) {
        //             flags.set(flag, flags.get(flag) + event.get("opt1").get("consequences").get(flag));
        //         } else {
        //             flags.set(flag, 1);
        //         }
        //     }
        // }
        // option2.onClick = function(event : hxd.Event) {
        //     var flags = player.flags;
        //     for (String flag : event.get("opt2").get("consequences").keyset()) {
        //         if (flags.keyset.contains(flag)) {
        //             flags.set(flag, flags.get(flag) + event.get("opt2").get("consequences").get(flag));
        //         } else {
        //             flags.set(flag, 1);
        //         }
        //     }
        // }
        return null;
    }


}