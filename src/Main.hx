import data.EventsData;
import data.PlayerData;
import scenes.Level;
import scenes.MapLevel;
import scenes.DialogueLevel;
import hxd.Res;

class Main extends hxd.App {

    var curLevel: Level;

    override function init() {
        hxd.Res.initEmbed();
        var playerData = new PlayerData();
        var eventsData = new EventsData();

        curLevel = new DialogueLevel(eventsData, playerData);
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
