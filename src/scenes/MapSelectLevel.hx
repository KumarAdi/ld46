package scenes;

import data.EventsData;
import h2d.Scene;
import hxd.Res;
import h2d.col.Bounds;
import h2d.col.Point;
import data.MapData;
import data.PlayerData;
import hxd.Event;

class MapSelectLevel extends MapLevel {

    private var eventData: EventsData;

    public function new(parent: Level) {
        this.scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);

        playerData = PlayerData.getInstance();
        eventData = new EventsData();

        this.townTile = Res.img.town1.toTile();
        townTile.scaleToSize(200, 200);
        var townSize = new Point(townTile.width, townTile.height);
        var playableArea = new Bounds();
        playableArea.setMin(new Point(0, 0).add(townSize.clone().scale(0.5)));
        playableArea.setMax(new Point(scene.width, scene.height).sub(townSize.clone().scale(0.5)));
        mapData = new MapData(townSize.length()/2, playableArea);
        
        super(parent, scene, mapData, playerData, townTile);

        for (town => cell in this.towns) {
            town.onClick = function (e: Event) {
                if (cell.getNeighbors().indexOf(curTown.point) != -1) {
                    // launch dialog
                    curTown = cell;
                    nextLevel = new DialogueLevel(this, eventData, playerData);
                }
            }
        }
    }

    override function init() {
        super.init();
    }
}