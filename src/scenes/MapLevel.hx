package scenes;

import h2d.Tile;
import h2d.col.Voronoi.Cell;
import hxd.res.DefaultFont;
import h2d.Text;
import data.PlayerData;
import h2d.Object;
import hxd.Event;
import h2d.Interactive;
import h2d.Graphics;
import hxd.Res;
import h2d.col.Point;
import h2d.Bitmap;
import h2d.Scene;
import h2d.col.Bounds;
import data.MapData;

class MapLevel implements Level {
    private final townTile: Tile;

    private var playerMarker: Bitmap;
    public var scene: Scene;
    private var mapData: MapData;
    private var playerData: PlayerData;
    private var parent: Level;
    private var nextLevel: Null<Level>;
    private var towns: Map<Interactive, Cell>;
    private var curTown: Cell;

    public function new(parent: Level, ?scene: Scene, mapData: MapData, playerData: PlayerData, townTile: Tile) {
        if (scene == null) {
            scene = new Scene();
            scene.scaleMode = LetterBox(1920, 1080);
        } else {
            this.scene = scene;
        }
        this.parent = parent;
        this.mapData = mapData;
        this.playerData = playerData;
        this.townTile = townTile;

        var townSize = new Point(townTile.width, townTile.height);

        scene.addChild(new Bitmap(Res.img.grass.toTile()));
        
        towns = new Map();
        var roads = new Object(scene);
        var townLayer = new Object(scene);

        var lineDrawer = new Graphics(roads);
        lineDrawer.lineStyle(10);
        for (cell in mapData.diagram.cells) {
            var town = cell.point;
            var townSprite = new Bitmap(townTile, townLayer);
            townSprite.setPosition(town.x - (townSize.clone().x/2), town.y - (townSize.clone().y/2));

            var interactiveTile = new Interactive(townSize.x, townSize.y, townSprite);

            interactiveTile.onOver = function (e: Event) {
                for (neighbor in cell.getNeighbors()) {
                    lineDrawer.moveTo(town.x, town.y);
                    lineDrawer.lineTo(neighbor.x, neighbor.y);
                }
            }

            interactiveTile.onOut = function (e: Event) {
                lineDrawer.clear();
                lineDrawer = new Graphics(roads);
                lineDrawer.lineStyle(10);
            }

            towns.set(interactiveTile, cell);

            if (curTown == null || cell.point.x < curTown.point.x) {
                curTown = cell;
            }
        }

        var caravanTile = Res.img.caravan.toTile();
        caravanTile.scaleToSize(townSize.x * 0.8, townSize.y * 0.8);
        playerMarker = new Bitmap(caravanTile, scene);

        var x = new Text(DefaultFont.get(), scene);
        x.text = "X";
        x.scale(10);

        var xBtn = new Interactive(x.textHeight, x.textHeight, x);

        xBtn.onClick = function (e: Event) {
            nextLevel = parent;
        }
    }

    public function init() {

    }

    public function update(dt: Float): Null<Level> {
        playerMarker.x = curTown.point.x - (townTile.width * 0.4);
        playerMarker.y = curTown.point.y - (townTile.height * 0.4);

        // null out nextLevel so it's not set when we come back
        var ret = nextLevel;
        nextLevel = null;
        return ret;
    }
}