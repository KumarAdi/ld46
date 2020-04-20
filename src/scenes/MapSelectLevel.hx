package scenes;

import hxd.res.Sound;
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
        eventData = new EventsData(Res.data.normal.entry.getText());

        this.townTile = Res.img.town1.toTile();
        townTile.scaleToSize(170, 170);
        var townSize = new Point(townTile.width, townTile.height);
        var playableArea = new Bounds();
        playableArea.setMin(new Point(0, 0).add(townSize.clone().scale(0.5).add(new Point(25, 0))));
        playableArea.setMax(new Point(scene.width, scene.height).sub(townSize.clone().scale(0.5)).sub(new Point(25, 150)));
        mapData = new MapData(townSize.length()/2, playableArea);

        while (mapData.diagram.cells.length < 7) {
            mapData = new MapData(townSize.length()/2, playableArea);
        }

        // set start and end towns
        for (cell in mapData.diagram.cells) {
            if (curTown == null || cell.point.x < curTown.point.x) {
                curTown = cell;
            }

            if (endTown == null || cell.point.x > endTown.point.x) {
                endTown = cell;
            }
        }
        
        super(parent, scene, mapData, playerData, townTile, curTown, endTown);

        x.remove();

        for (town => cell in this.towns) {
            town.onClick = function (e: Event) {
                if (cell.getNeighbors().indexOf(curTown.point) != -1) {
                    // play sound effect
                    var horseSfx:Sound = null;
                    //If we support mp3 we have our sound
                    if(hxd.res.Sound.supportedFormat(Mp3)){
                        horseSfx = hxd.Res.sound.horse;
                    }  

                    if(horseSfx != null){
                        //Play the music and loop it
                        horseSfx.play(false);
                    }

                    // launch dialog
                    curTown = cell;
                    if (curTown == endTown) {
                        nextLevel = new CutsceneDialogueLevel(
                            new MainMenu(), new EventsData(Res.data.endings.entry.getText()),
                            playerData, mapData, townTile,
                            curTown, endTown, Res.img.ending.toTile(), 2);
                    } else if (visited.indexOf(cell) == -1) {
                        nextLevel = new DialogueLevel(this, eventData, playerData, mapData, townTile, curTown, endTown);
                    }
                }
            }
        }
    }

    override function init() {
        super.init();

        // call update resource
        updateResources();

        if (playerData.checkProperty("supplies", 0, -1)) {
            nextLevel = new CutsceneDialogueLevel(
                new MainMenu(), new EventsData(Res.data.endings.entry.getText())
                , playerData, mapData, townTile,
                curTown, endTown, Res.img.intro.toTile(), 0);
        }

        if (playerData.checkProperty("curse", 100)) {
            nextLevel = new CutsceneDialogueLevel(
                new MainMenu(), new EventsData(Res.data.endings.entry.getText()),
                playerData, mapData, townTile,
                curTown, endTown, Res.img.intro.toTile(), 1);
        }
    }

    private function updateResources() {
        // update player stats
        playerData.incrementProperty("curse", 7);
        //playerData.incrementProperty("curse", Math.floor((Math.random() * 7) + 7));
        playerData.incrementProperty("supplies", -1);
    }
}