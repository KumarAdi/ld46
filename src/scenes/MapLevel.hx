package scenes;

import h2d.Slider;
import h2d.col.Voronoi.Diagram;
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
    private var endTown: Cell;
    private var roads: Object;
    private var curse: Text;
    private var curseBar: Bitmap;
    private var curseBarFillTile: Tile;
    private var curseIcon: Bitmap;
    private var supplies: Text;
    private var gold: Text;

    public function new(parent: Level, ?scene: Scene, mapData: MapData, playerData: PlayerData, townTile: Tile, curTown: Cell, endTown: Cell) {
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
        this.curTown = curTown;

        var townSize = new Point(townTile.width, townTile.height);

        scene.addChild(new Bitmap(Res.img.grass.toTile()));
        
        towns = new Map();

        roads = new Object(scene);
        var townLayer = new Object(scene);

        var highlighter = new Graphics(roads);
        highlighter.lineStyle(10, 0xFFFFFF);

        for (cell in mapData.diagram.cells) {
            var town = cell.point;
            var townSprite = new Bitmap(townTile, townLayer);
            townSprite.setPosition(town.x - (townSize.clone().x/2), town.y - (townSize.clone().y/2));

            var interactiveTile = new Interactive(townSize.x, townSize.y, townSprite);

            interactiveTile.onOver = function (e: Event) {
                for (neighbor in cell.getNeighbors()) {
                    highlighter.moveTo(town.x, town.y);
                    highlighter.lineTo(neighbor.x, neighbor.y);
                }
            }

            interactiveTile.onOut = function (e: Event) {
                highlighter.clear();
                highlighter = new Graphics(roads);
                highlighter.lineStyle(10, 0xFFFFFF);
            }

            towns.set(interactiveTile, cell);
        }

        var caravanTile = Res.img.caravan.toTile();
        caravanTile.scaleToSize(townSize.x * 0.9, townSize.y * 0.9);
        playerMarker = new Bitmap(caravanTile, scene);

        // UI STUFF

        // Init font
        var uiFont = Res.fonts.centurygothic.toFont();
        
        // var uiBgTile = Tile.fromColor(0, 1920, 200);
        // var uiBg = new Bitmap(uiBgTile, scene);
        var uiBg = new Object();
        uiBg.y = scene.height - 150;
        scene.addChild(uiBg);

        // Init back button
        var x = new Text(uiFont, scene);
        x.text = "Back to Dialogue";
        var xBtn = new Interactive(x.textHeight, x.textHeight, x);
        xBtn.onClick = function (e: Event) {
            nextLevel = parent;
        }

        // Init curse bar
        var curseBarTile = Res.img.bar.toTile();
        curseBarTile.scaleToSize(480, 120);
        curseBar = new Bitmap(curseBarTile, uiBg);
        curseBar.x = 150;
        trace(playerData.flags.get("curse"));

        curseBarFillTile = Tile.fromColor(0x3c2a59);
        curseBarFillTile.scaleToSize(40, 33);
        var curseBarFill = new Bitmap(curseBarFillTile, curseBar);
        curseBarFill.x = 46;
        curseBarFill.y = 43;
        var curseTile = Res.img.curse.toTile();
        curseTile.scaleToSize(120, 120);
        curseIcon = new Bitmap(curseTile, curseBar);
        curseIcon.x = 360;

        // Init curse text
        curse = new Text(uiFont, curseBar);
        curse.text = "The Curse";
        curse.x = (curseBar.getBounds().width / 2) - (curse.textWidth / 2) - 5;
        curse.y = curseBar.getBounds().height - 24;

        // Init relics
        var crystalMissingTile = Res.img.crystalmissing.toTile();
        crystalMissingTile.scaleToSize(120,120);
        var crystalMissingIcon = new Bitmap(crystalMissingTile, uiBg);
        crystalMissingIcon.x = curseBar.x + curseBar.getBounds().width + 100;

        var orbMissingTile = Res.img.orbmissing.toTile();
        orbMissingTile.scaleToSize(120,120);
        var orbMissingIcon = new Bitmap(orbMissingTile, uiBg);
        orbMissingIcon.x = crystalMissingIcon.x + crystalMissingIcon.getBounds().width + 50;

        var stoneMissingTile = Res.img.stonemissing.toTile();
        stoneMissingTile.scaleToSize(120,120);
        var stoneMissingIcon = new Bitmap(stoneMissingTile, uiBg);
        stoneMissingIcon.x = orbMissingIcon.x + orbMissingIcon.getBounds().width + 50;

        // Init relics text
        var relics = new Text(uiFont, uiBg);
        relics.text = "The Relics";
        relics.x = orbMissingIcon.x + (orbMissingIcon.getBounds().width / 2) - (relics.textWidth / 2) - 5;
        relics.y = orbMissingIcon.getBounds().height - 24;
        
        // Init supplies text
        var suppliesTitle = new Text(uiFont, uiBg);
        suppliesTitle.text = "Supplies";
        supplies = new Text(Res.fonts.alagard.toFont(), suppliesTitle);
        supplies.x = 50;
        supplies.y = 40;
        suppliesTitle.x = scene.width - 350;       
        suppliesTitle.y = 30; 

        // Init money text
        var goldTitle = new Text(uiFont, uiBg);
        goldTitle.text = "Satchel";
        gold = new Text(Res.fonts.alagard.toFont(), goldTitle);
        gold.x = 50;
        gold.y = 40;
        goldTitle.x = suppliesTitle.x - 250;
        goldTitle.y = 30;
    }

    public function init() {
        var roadLines = new Graphics(roads);
        roadLines.lineStyle(15);

        for (cell in mapData.diagram.cells) {
            var town = cell.point;
            for (neighbor in cell.getNeighbors()) {
                roadLines.moveTo(town.x, town.y);
                roadLines.lineTo(neighbor.x, neighbor.y);
            }
        }
    }

    public function update(dt: Float): Null<Level> {
        playerMarker.x = curTown.point.x - (townTile.width * 0.45);
        playerMarker.y = curTown.point.y - (townTile.height * 0.45);

        // var cursePercent = playerData.flags.get("curse") / 10;
        curseBarFillTile.scaleToSize((40 * playerData.flags.get("curse")), 33);
        //curseIcon.x = curseBarFill.getBounds().width - 50;
        
        supplies.text = playerData.flags.get("supplies") + " days";
        gold.text = playerData.flags.get("money") + " g";

        // null out nextLevel so it's not set when we come back
        var ret = nextLevel;
        nextLevel = null;
        return ret;
    }
}