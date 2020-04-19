package scenes;

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
    public var scene: Scene;
    private var mapData: MapData;

    public function new() {
        scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);
    }

    public function init() {
        var townTile = Res.img.town1.toTile();
        townTile.scaleToSize(200, 200);
        var townSize = new Point(townTile.width, townTile.height);

        var playableArea = new Bounds();
        playableArea.setMin(new Point(0, 0).add(townSize.clone().scale(0.5)));
        playableArea.setMax(new Point(scene.width, scene.height).sub(townSize.clone().scale(0.5)));

        scene.addChild(new Bitmap(Res.img.grass.toTile()));

        var roads = new Object(scene);

        mapData = new MapData(townSize.length()/2, playableArea);
        var lineDrawer = new Graphics(roads);
        lineDrawer.lineStyle(10);
        for (cell in mapData.diagram.cells) {
            var town = cell.point;
            var townSprite = new Bitmap(townTile);
            townSprite.setPosition(town.x - (townSize.clone().x/2), town.y - (townSize.clone().y/2));
            scene.addChild(townSprite);

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
        }
    }

    public function update(dt: Float): Null<Level> {
        return null;
    }
}