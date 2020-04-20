package scenes;

import h2d.filter.Outline;
import h2d.col.Voronoi.Cell;
import hxd.Event;
import h2d.Text;
import data.MapData;
import h2d.Interactive;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Scene;
import data.EventsData;
import data.PlayerData;
import hxd.Res;
import h2d.Font;

class CutsceneDialogueLevel extends DialogueLevel {

    private var fadeIn: Bool;
    private var startLevel: Bool;

    public function new(parent: Level, eventsData: EventsData, playerData: PlayerData, mapData: MapData, townTile: Tile, curTown: Cell, endTown: Cell, bgTile: Tile, ?scenario: Int) {
        super(parent, eventsData, playerData, mapData, townTile, curTown, endTown, scenario);

        this.bgTile = Res.img.village_bg.toTile();
        if (bgTile != null) {
            this.bgTile = bgTile;
            fadeIn = true;
        }
    }

    override function init() {
        super.init();

        viewMap.remove();

        textbox.alpha = 0;

        var start = new Text(Res.fonts.pixopbold.toFont(), scene);
        start.text = "-Click to Continue-";
        start.filter = new Outline(2,0x000000);
        start.x = scene.width/2 - start.textWidth/2;
        start.y = 4 * (scene.height/5);

        var startBtn = new Interactive(start.textWidth, start.textHeight, start);
        startBtn.onClick = function (e: Event) {
            startLevel = true;
            start.remove();
        }
    }

    override function update(dt:Float):Null<Level> {
        if (startLevel) {
            if (textbox.alpha <= 1 - dt) {
                textbox.alpha += dt;
            }
        }
        return super.update(dt);
    }
}