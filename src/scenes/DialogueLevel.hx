package scenes;

import h2d.Interactive;
import haxe.display.Display.Package;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Scene;
import data.EventsData;
import data.PlayerData;
import hxd.Res;

class DialogueLevel implements Level {
    public var scene: Scene;
    public var textbox: Bitmap;
    public var option1: Interactive;
    public var option2: Interactive;
    public var eventData: EventData;
    public var playerData: PlayerData;

    public function new(eventsData: EventsData, playerData: PlayerData) {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);
        var scenario = Math.floor(Math.random() * eventsData.events.length); // just random picking for now, might need to add logic based on flags
        eventData = eventsData.events[scenario];
        eventsData.events.remove(eventData); // remove the encountered event from the list
        this.playerData = playerData;
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
        main.text = eventData.main;
        main.textColor = 0xFFFFFF;
        textbox.addChild(main);

        var opt1 = new h2d.Text(font);
        opt1.text = eventData.opt1.text;
        opt1.textColor = 0xFFFFFF;
        opt1.y = 100;
        option1 = new h2d.Interactive(300, 100, opt1); // need to change size
        option1.onClick = function(event : hxd.Event) {
            var flags = playerData.flags;
            for (consequence in eventData.opt1.consequences) {
                if (flags.exists(consequence.flag)) {
                    flags.set(consequence.flag, flags.get(consequence.flag) + consequence.magnitude);
                } else {
                    flags.set(consequence.flag, consequence.magnitude);
                }
            }
        }
        textbox.addChild(opt1); // and placement

        var opt2 = new h2d.Text(font);
        opt2.text = eventData.opt2.text;
        opt2.textColor = 0xFFFFFF;
        opt2.y = 150;
        option2 = new h2d.Interactive(300, 100, opt2);
        option2.onClick = function(event : hxd.Event) {
            var flags = playerData.flags;
            for (consequence in eventData.opt2.consequences) {
                if (flags.exists(consequence.flag)) {
                    flags.set(consequence.flag, flags.get(consequence.flag) + consequence.magnitude);
                } else {
                    flags.set(consequence.flag, consequence.magnitude);
                }
            }
        }
        textbox.addChild(opt2);
    }

    public function update(dt: Float): Null<Level> {
        return null;
    }


}