package scenes;

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
            {text: "The caravan is you", loc: curTown.point},
            {text: "The black lines are roads", loc: curTown.point},
            {text: "You can travel to neighboring towns by clicking on them", loc: curTown.getNeighbors()[0]},
            {text: "Your goal is to get to this town", loc: endTown.point}
        ];

        var tutorialTile = Tile.fromColor(0x000000, 400, 100);
        var tutorialBg = new Bitmap(tutorialTile, scene);
        var tutorialBox = new Interactive(400, 200, tutorialBg);
        var tutorialText = new Text(Res.fonts.centurygothic.toFont(), tutorialBg);
        tutorialText.maxWidth = tutorialTile.width;

        tutorialBg.x = curTown.point.x - (townTile.width / 2);
        tutorialBg.y = curTown.point.y - townTile.height/2 - 100;

        tutorialBox.onClick = function (e: Event) {
            tutorialIdx += 1;
            if (tutorialIdx >= tutorials.length) {
                tutorialBg.remove();
                tutorialBg = null;
                return;
            }

            var tutorial = tutorials[tutorialIdx];
            updateTutorial(tutorialText, tutorialBg, tutorial);
        }

        var tutorial = tutorials[tutorialIdx];
        updateTutorial(tutorialText, tutorialBg, tutorial);
    }

    private function updateTutorial(tutorialText: Text, tutorialBg: Bitmap ,tutorial: {text: String, loc: Point}): Void {
        tutorialText.text = tutorial.text + "\n click this box to continue>";
        tutorialBg.tile.scaleToSize(tutorialText.maxWidth, tutorialText.textHeight);
        tutorialBg.x = Math.min(scene.width - tutorialText.maxWidth, tutorial.loc.x - (townTile.width / 2));
        tutorialBg.y = Math.max(0, tutorial.loc.y - (townTile.height / 2 + tutorialText.textHeight));
    }
}