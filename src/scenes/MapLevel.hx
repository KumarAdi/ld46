package scenes;

import h2d.Slider;
import h2d.col.Voronoi.Diagram;
import h2d.filter.ColorMatrix;
import h2d.filter.Outline;
import h2d.Tile;
import h2d.col.Voronoi.Cell;
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
    private var crystalIcon: Bitmap;
    private var orbIcon: Bitmap;
    private var stoneIcon: Bitmap;
    private var uiBg: Object;
    private var endBtn: Interactive;
    private var x: Text; // the button to close the map view
    private final visited = new Array<Cell>();

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
        highlighter.lineStyle(8, 0xFFFFFF);


        var outline = new Outline(2, 0xFFFFFF);
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
                if (visited.indexOf(cell) == -1) {
                    townSprite.filter = outline;
                }
            }

            interactiveTile.onOut = function (e: Event) {
                highlighter.clear();
                highlighter = new Graphics(roads);
                highlighter.lineStyle(8, 0xFFFFFF);
                if (visited.indexOf(cell) == -1) {
                    townSprite.filter = null;
                }
            }

            towns.set(interactiveTile, cell);
            if (cell == endTown) {
                endBtn = interactiveTile;
            }
        }

        var flagTile = Res.img.wizardflag.toTile();
        flagTile.scaleToSize(townTile.width, townTile.height);
        var flag = new Bitmap(flagTile, endBtn.parent);
        flag.x = townTile.width / 2 - 25;
        flag.y = -25;

        var caravanTile = Res.img.caravan.toTile();
        caravanTile.scaleToSize(townSize.x * 0.9, townSize.y * 0.9);
        playerMarker = new Bitmap(caravanTile, scene);

        // UI STUFF

        // Init font
        var uiFont = Res.fonts.centurygothic.toFont();
        uiBg = new Object();
        uiBg.y = scene.height - 150;
        scene.addChild(uiBg);

        // Init back button
        x = new Text(uiFont, scene);
        x.text = "Back to Dialogue";
        var xBtn = new Interactive(x.textHeight, x.textHeight, x);
        xBtn.onClick = function (e: Event) {
            nextLevel = parent;
        }

        // Init ui bg
        var bottomBlurTile = Res.img.blur.toTile();
        bottomBlurTile.scaleToSize(1920, 150);
        var bottomBlur = new Bitmap(bottomBlurTile, uiBg);

        // Init curse bar
        var curseBarTile = Res.img.bar.toTile();
        curseBarTile.scaleToSize(480, 120);
        curseBar = new Bitmap(curseBarTile, uiBg);
        curseBar.x = 150;

        curseBarFillTile = Tile.fromColor(0x3c2a59);
        curseBarFillTile.scaleToSize(40, 33);
        var curseBarFill = new Bitmap(curseBarFillTile, curseBar);
        curseBarFill.x = 46;
        curseBarFill.y = 43;
        var curseIconTile = Res.img.curse.toTile();
        curseIconTile.scaleToSize(120, 120);
        curseIcon = new Bitmap(curseIconTile, curseBar);
        curseIcon.x = 360;

        // Init curse text
        curse = new Text(uiFont, curseBar);
        curse.text = "The Curse";
        curse.x = (curseBar.getBounds().width / 2) - (curse.textWidth / 2) - 5;
        curse.y = curseBar.getBounds().height - 24;

        // Init relics
        var crystalMissingTile = Res.img.crystalmissing.toTile();
        crystalMissingTile.scaleToSize(120,120);
        crystalIcon = new Bitmap(crystalMissingTile, uiBg);
        crystalIcon.x = curseBar.x + curseBar.getBounds().width + 100;

        var orbMissingTile = Res.img.orbmissing.toTile();
        orbMissingTile.scaleToSize(120,120);
        orbIcon = new Bitmap(orbMissingTile, uiBg);
        orbIcon.x = crystalIcon.x + crystalIcon.getBounds().width + 50;

        var stoneMissingTile = Res.img.stonemissing.toTile();
        stoneMissingTile.scaleToSize(120,120);
        stoneIcon = new Bitmap(stoneMissingTile, uiBg);
        stoneIcon.x = orbIcon.x + orbIcon.getBounds().width + 50;

        // Init relics text
        var relics = new Text(uiFont, uiBg);
        relics.text = "The Relics";
        relics.x = orbIcon.x + (orbIcon.getBounds().width / 2) - (relics.textWidth / 2) - 5;
        relics.y = orbIcon.getBounds().height - 24;
        
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
        roadLines.lineStyle(16, 0x8f6c3b);
        visited.push(curTown);

        for (town => cell in towns) {
            if (visited.indexOf(cell) != -1) {
                town.parent.filter = ColorMatrix.grayed();
            }
        }

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

        // update curse bar
        curseBarFillTile.scaleToSize((4 * playerData.getProperty("curse")), 33);
        // update supplies
        supplies.text = playerData.getProperty("supplies") + " days";
        // update money
        gold.text = playerData.getProperty("money") + " g";
        // update relics
        if (playerData.getProperty("cop") >= 1) {
            var crystalTile = Res.img.crystal.toTile();
            crystalTile.scaleToSize(120,120);
            crystalIcon = new Bitmap(crystalTile, uiBg);
            crystalIcon.x = curseBar.x + curseBar.getBounds().width + 100;
        }
        if (playerData.getProperty("orb") >= 1) {
            var orbTile = Res.img.orb.toTile();
            orbTile.scaleToSize(120,120);
            orbIcon = new Bitmap(orbTile, uiBg);
            orbIcon.x = crystalIcon.x + crystalIcon.getBounds().width + 50;
        }
        if (playerData.getProperty("heartstone") >= 1) {
            var stoneTile = Res.img.stone.toTile();
            stoneTile.scaleToSize(120,120);
            stoneIcon = new Bitmap(stoneTile, uiBg);
            stoneIcon.x = orbIcon.x + orbIcon.getBounds().width + 50;
        }

        // null out nextLevel so it's not set when we come back
        var ret = nextLevel;
        nextLevel = null;
        return ret;
    }
}