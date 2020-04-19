package scenes;

import h2d.Interactive;
import haxe.display.Display.Package;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Scene;
import data.EventsData;
import data.PlayerData;
import hxd.Res;
import h2d.Font;

class DialogueLevel implements Level {
    public var scene: Scene;
    public var textbox: Bitmap;
    public var optionListeners: Array<Interactive>;
    public var eventData: EventData;
    public var playerData: PlayerData;
    public var font: Font;
    private var parent: Level;
    private var done: Bool;

    public function new(parent: Level, eventsData: EventsData, playerData: PlayerData) {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);

        done = false;
        this.parent = parent;

        var scenarioIdx = Math.floor(Math.random() * eventsData.events.length); // just random picking for now, might need to add logic based on flags
        eventData = eventsData.events[scenarioIdx];
        eventsData.events.remove(eventData); // remove the encountered event from the list

        this.playerData = playerData;
    }

    public function init(): Void {
        // Init textbox

        var bgTile = Res.img.village_bg.toTile();
        var bg = new Bitmap(bgTile, scene);
        textbox = new Bitmap(Tile.fromColor(0x00AA00, Math.floor(scene.width / 2), Math.floor(scene.height / 2)), scene);
        textbox.x = 1920/2 - textbox.getBounds().width/2;
        textbox.y = 1080/2 - textbox.getBounds().height/2;
        // new Bitmap(Res.img.textbox.toTile(), scene); // needs james textbox
        // font = hxd.res.DefaultFont.get();
        font = Res.fonts.alagard.toFont();

        // Init first passage
        progressText("a");
    }

    public function update(dt: Float): Null<Level> {
        if (done) {
            return parent;
        }
        return null;
    }

    public function progressText(nextid: String): Void {

        // clear previous text
        textbox.removeChildren();

        // remove previous listeners
        optionListeners = new Array();

        // Init passage
        var passageData:PassageData = eventData.passages.filter(
            passage -> passage.id == nextid)[0];
        var passage = new h2d.Text(font);
        passage.text = passageData.text;
        passage.maxWidth = textbox.getBounds().width - 40;
        passage.textColor = 0xFFFFFF;
        textbox.addChild(passage);

        // Init next height for placement of options
        var nextHeight = passage.textHeight + 100;

        // Init options
        for (opt in passageData.options) {

            // if requirements not met, dont display option
            if (opt.requirements != null) {
                var flagsMet = true;
                for (flagRequired in opt.requirements) {
                    // overload to avoid null error
                    if (!playerData.flags.exists(flagRequired.flag) || playerData.flags.get(flagRequired.flag) < flagRequired.magnitude) {
                        flagsMet = false;
                        break;
                    }
                }
                if (!flagsMet) {
                    continue;
                }
            }
            var option = new h2d.Text(font);
            option.text = opt.text;
            option.maxWidth = textbox.getBounds().width - 40;
            option.textColor = 0xFFFFFF;
            option.x = 20;
            option.y = nextHeight;
            option.maxWidth = textbox.tile.width;
            textbox.addChild(option);

            // set up option onclick listener
            var optionListen = new h2d.Interactive(option.textWidth, option.textHeight, option);
            optionListen.onClick = function(event : hxd.Event) {
                var flags = playerData.flags;
                if (opt.consequences != null) {
                    for (consequence in opt.consequences) {
                        if (consequence.probability != null && Math.random() > consequence.probability) {
                            break;
                        }
                        if (flags.exists(consequence.flag)) {
                            flags.set(consequence.flag, flags.get(consequence.flag) + consequence.magnitude);
                        } else {
                            flags.set(consequence.flag, consequence.magnitude);
                        }
                    }
                }
                trace(opt.nextid);
                if (opt.nextid != null) {
                    progressText(opt.nextid);
                } else {
                    //otherwise close dialogue and go back to map level
                    done = true;
                }
            }
            optionListeners.push(optionListen);

            // increment next height
            nextHeight += option.textHeight + 50;
        }
    }
}