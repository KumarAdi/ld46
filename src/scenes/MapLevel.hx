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
        var townTile = Tile.fromColor(0xFF0000);//Res.img.town1.toTile();
        townTile.scaleToSize(200, 200);
        var townSize = new Point(townTile.width, townTile.height);

        var playableArea = new Bounds();
        playableArea.setMin(new Point(0, 0).add(townSize.scale(0.5)));
        playableArea.setMax(new Point(scene.width, scene.height).sub(townSize.scale(0.5)));

        scene.addChild(new Bitmap(Res.img.grass.toTile()));

        mapData = new MapData(townSize.length() / 2, playableArea);
        for (town in mapData.towns) {
            var townSprite = new Bitmap(townTile);
            townSprite.setPosition(town.x - townSize.x/2, town.y - townSize.y/2);
            scene.addChild(townSprite);
        }
    }

    public function update(dt: Float): Null<Level> {
        return null;
    }
}