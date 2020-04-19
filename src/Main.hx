import data.Events;
import data.Player;
import scenes.Level;
import scenes.MapLevel;
import scenes.Dialogue;
import hxd.Res;

class Main extends hxd.App {

    var curLevel: Level;

    override function init() {
        hxd.Res.initEmbed();
        var player = new Player();
        var json = Res.data.test.entry.getText();
        trace(json);
        var events = new Events(json);

        curLevel = new Dialogue(events, player);
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
