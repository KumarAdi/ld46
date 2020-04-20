package scenes;

import h2d.Object;
import h2d.col.Point;
import hxd.Res;
import h2d.Text;
import hxd.Event;
import h2d.Interactive;
import h2d.Tile;
import h2d.Bitmap;

class FirstLevel extends MapSelectLevel {

    private var tutorialIdx: Int;

    public function new(parent: Level) {
        super(parent);

        // launch dialouge right when map opens up too
        nextLevel = new CutsceneDialogueLevel(this, eventData, playerData, mapData,
                                      townTile, curTown, endTown, Res.img.intro.toTile(), 0);
        tutorialIdx = 0;

        var tutorials = [
            {text: "This is your caravan", loc: curTown.point},
            {text: "The brown lines are roads", loc: curTown.point},
            {text: "You can travel to neighboring towns by clicking on them", loc: curTown.getNeighbors()[0]},
            {text: "The Great Wizard lives in this town!", loc: endTown.point},
            {text: "This is how many supplies you have. Traveling from town to town takes up 1 unit of supplies.", loc: new Point((scene.width -350), uiBg.y + 50)},
            {text: "This is the amount of gold contained in your satchel. Use this to trade with other townsfolk.", loc: new Point((scene.width - 600), uiBg.y + 50)},
            {text: "These are The Relics. When you accquire one, it will show up here.", loc: new Point(orbIcon.x - 40, uiBg.y + 50)},
            {text: "This bar shows the power of the curse. Find The Relics and bring your dragon to The Great Wizard before it's too late!", loc: new Point(curseBar.x + 100, uiBg.y + 80)}
        ];

        // init tutorial box
        var tutorialParent = new Object(scene);
        var tutorialTile = Tile.fromColor(0x000000);
        tutorialTile.scaleToSize(380, 300);
        var tutorialBg = new Bitmap(tutorialTile, tutorialParent);
        tutorialBg.alpha = 0.8;
        var tutorialBox = new Interactive(tutorialBg.getBounds().width, tutorialBg.getBounds().height, tutorialParent);
        var tutorialText = new Text(Res.fonts.centurygothic.toFont(), tutorialParent);
        tutorialText.maxWidth = tutorialBg.getBounds().width - 26;
        tutorialText.x = 13;
        tutorialText.y = 9;

        // set tutorial box pos
        tutorialParent.x = curTown.point.x - (townTile.width / 2);
        tutorialParent.y = curTown.point.y - townTile.height/2 - 100;

        tutorialBox.onClick = function (e: Event) {
            tutorialIdx += 1;
            if (tutorialIdx >= tutorials.length) {
                tutorialParent.remove();
                tutorialParent = null;
                return;
            }

            var tutorial = tutorials[tutorialIdx];
            updateTutorial(tutorialParent, tutorialText, tutorialBg, tutorial, tutorialTile, tutorialBox);
        }

        var tutorial = tutorials[tutorialIdx];
        updateTutorial(tutorialParent, tutorialText, tutorialBg, tutorial, tutorialTile, tutorialBox);
    }

    private function updateTutorial(tutorialParent: Object, tutorialText: Text, tutorialBg: Bitmap ,tutorial: {text: String, loc: Point}, tutorialTile: Tile, tutorialBox: Interactive): Void {
        // update tutorial box text, size, and pos
        tutorialText.text = tutorial.text + "\n\n   -Click here to continue-";
        tutorialTile.scaleToSize(380, tutorialText.textHeight + 20);
        tutorialBox.width = tutorialBg.getBounds().width;
        tutorialBox.height = tutorialBg.getBounds().height;
        tutorialParent.x = Math.min(scene.width - tutorialText.maxWidth - 40, tutorial.loc.x - (townTile.width / 2));
        tutorialParent.y = Math.max(20, tutorial.loc.y - (townTile.height / 2 + tutorialText.textHeight));
    }
}