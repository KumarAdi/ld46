package scenes;

import h2d.Scene;
import data.EventsData;
import data.PlayerData;

class MainMenu implements Level {
    public var scene: Scene;

    public function new() {
        this.scene = new Scene();
    }

    public function init() {
        trace("Menu");
    }

    public function update(dt: Float): Level {
        return new FirstLevel(this);
    }
}