package scenes;

import h2d.col.Voronoi.Cell;
import hxd.Event;
import h2d.Text;
import data.MapData;
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
    private var mapData: MapData;
    private var townTile: Tile;
    private var nextLevel: Null<Level>;
    private var curTown: Cell;
    private var endTown: Cell;

    public function new(parent: Level, eventsData: EventsData, playerData: PlayerData, mapData: MapData, townTile: Tile, curTown: Cell, endTown: Cell, ?scenario: Int) {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);

        done = false;
        this.parent = parent;

        var scenarioIdx = Math.floor(Math.random() * eventsData.events.length); // just random picking for now, might need to add logic based on flags
        if (scenario != null) {
            scenarioIdx = scenario;
        }
        eventData = eventsData.events[scenarioIdx];
        eventsData.events.remove(eventData); // remove the encountered event from the list

        this.playerData = playerData;
        this.mapData = mapData;
        this.townTile = townTile;
        this.curTown = curTown;
        this.endTown = endTown;
    }

    public function init(): Void {
        // Init Bg
        var bgTile = Res.img.village_bg.toTile();
        var bg = new Bitmap(bgTile, scene);
        
        // Init textbox
        textbox = new Bitmap(Tile.fromColor(0x000000, Math.floor(scene.width / 2), Math.floor(scene.height / 2)), scene);
        textbox.x = 1920/2 - textbox.getBounds().width/2;
        textbox.y = 1080/2 - textbox.getBounds().height/2;
        textbox.alpha = 1;
        // new Bitmap(Res.img.textbox.toTile(), scene); // needs james textbox
        // font = hxd.res.DefaultFont.get();
        font = Res.fonts.alagard.toFont();

        // Init map view button
        var viewMap = new Text(Res.fonts.pixop.toFont(), scene);
        viewMap.text = "VIEW MAP";
        viewMap.scale(5);

        var viewMapBtn = new Interactive(viewMap.textWidth, viewMap.textHeight, viewMap);

        viewMapBtn.onClick = function (e: Event) {
            nextLevel = new MapLevel(this, scene, mapData, playerData, townTile, curTown, endTown);
        }

        // Init first passage
        progressText("a");
    }

    public function update(dt: Float): Null<Level> {
        if (done) {
            return parent;
        }

        // null out nextLevel so it's not set when we come back
        var ret = nextLevel;
        nextLevel = null;
        return ret;
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
        passage.x = 20;
        passage.y = 20;
        passage.maxWidth = textbox.getBounds().width - 40;
        passage.textColor = 0xFFFFFF;
        passage.alpha = 1;
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
            option.alpha = 1;
            textbox.addChild(option);

            // set up option onclick listener
            var optionListen = new h2d.Interactive(option.textWidth, option.textHeight, option);
            optionListen.onClick = function(event : hxd.Event) {
                if (opt.outcomes != null) {

                    var outcome= opt.outcomes[0];
                    if (opt.outcomes.length > 1) { // there are multiple outcomes with different probs
                        for (currentOutcome in opt.outcomes) {
                            if ((Math.random() * 100) > currentOutcome.probability) {
                                outcome = currentOutcome;
                                break;
                            }
                        }
                    }

                    if (outcome.consequences != null) {
                        for (consequence in outcome.consequences) {
                            var flags = playerData.flags;
                            if (flags.exists(consequence.flag)) {
                                flags.set(consequence.flag, flags.get(consequence.flag) + consequence.magnitude);
                            } else {
                                flags.set(consequence.flag, consequence.magnitude);
                            }
                        }
                    }
                    trace(outcome.nextid);
                    progressText(outcome.nextid);
                } else { // outcome is null
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