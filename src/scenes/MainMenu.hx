package scenes;

import h2d.filter.Outline;
import h2d.Object;
import hxd.Res;
import hxd.Event;
import h2d.Interactive;
import h2d.Text;
import h2d.Scene;
import hxd.res.Sound;
import data.EventsData;
import data.PlayerData;

class MainMenu implements Level {
    public var scene: Scene;
    private var startLevel: Bool;
    private var start: Text;
    var time = 0.;
    var stime = 0.;

    public function new() {
        this.scene = new Scene();
        scene.scaleMode = LetterBox(1920, 1080);
        startLevel = false;

        // Init map view button
        var title = new Text(Res.fonts.alagard.toFont(), scene);
        title.text = "The Dragon's Curse";
        title.x = scene.width/2 - title.textWidth/2;
        title.y = scene.height/3;

        var startParent = new Object(scene);
        start = new Text(Res.fonts.pixopbold.toFont(), startParent);
        start.text = "-Click to Begin-";
        start.filter = new Outline(2,0x000000);
        startParent.x = scene.width/2 - start.textWidth/2;
        startParent.y = 4 * (scene.height/5);
        start.visible = false;

        var startBtn = new Interactive(scene.width, scene.height, scene);
        startBtn.onClick = function (e: Event) {
            startLevel = true;
        }
        
        // init bgm
        var bgm:Sound = null;
        //If we support mp3 we have our sound
        if(hxd.res.Sound.supportedFormat(Mp3)){
            bgm = hxd.Res.sound.adventure;
        }  

        if(bgm != null){
            //Play the music and loop it
            bgm.play(true);
        }
    }

    public function init() {
        PlayerData.resetInstance();
    }

    public function update(dt: Float): Null<Level> {
        dt *= 60;
		time += dt;
		stime += dt;
		if( stime > 30 ) {
			start.visible = !start.visible;
			stime = 0;
		}
        if (startLevel) {
            return new FirstLevel(this);
        }
        return null;
    }
}