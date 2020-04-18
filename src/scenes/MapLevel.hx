package scenes;

import hxd.Res;
import h2d.col.Point;
import h2d.Bitmap;
import h2d.Tile;
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
        var playableArea = new Bounds();
        playableArea.setMin(new Point(200, 200));
        playableArea.setMax(new Point(scene.width - 200, scene.height - 200));
        scene.addChild(new Bitmap(Res.img.grass.toTile()));
        mapData = new MapData(scene.width / 10, playableArea);
        var townTile = Res.img.town1.toTile();
        townTile.scaleToSize(400, 400);
        for (town in mapData.towns) {
            var townSprite = new Bitmap(townTile);
            townSprite.setPosition(town.x - 200, town.y - 200);
            scene.addChild(townSprite);
        }
    }

    public function update(dt: Float): Null<Level> {
        return null;
    }
}