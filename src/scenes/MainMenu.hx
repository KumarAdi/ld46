package scenes;

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
        startLevel = false;

        // Init map view button
        var title = new Text(Res.fonts.alagard.toFont(), scene);
        title.text = "The Dragon's Curse";
        title.x = scene.width/2 - title.textWidth/2;
        title.y = scene.height/3;

        start = new Text(Res.fonts.pixop.toFont(), scene);
        start.text = "-Click to Begin-";
        start.x = scene.width/2 - start.textWidth/2;
        start.y = 2 * (scene.height/3);
        start.visible = false;

        var startBtn = new Interactive(start.textWidth, start.textHeight, start);
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
        trace("Menu");
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