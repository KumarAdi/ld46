import scenes.Chopping;
import scenes.Level;
import scenes.Kneading;

class Main extends hxd.App {

    var curLevel: Level;

    override function init() {
        hxd.Res.initEmbed();

        curLevel = new Kneading();
        curLevel.init();
    }
    static function main() {
        new Main();
    }

    override function update(dt:Float) {
        if (s2d != curLevel.scene) {
            setScene(curLevel.scene, true);
        }
        var nextLevel = curLevel.update(dt);
        if (nextLevel != null) {
            curLevel = nextLevel;
            curLevel.init();
        }
    }
}
