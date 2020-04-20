package data;

import haxe.ds.HashMap;

class PlayerData {
    private static var instance: PlayerData;
    private var flags: Map<String, Int>;

    private function new() {
        flags = new Map();
        flags.set("curse", 1);
        flags.set("supplies", 3);
        flags.set("money", 3);
    }

    public static function getInstance(): PlayerData {
        if (instance == null) {
            instance = new PlayerData();
        }

        return instance;
    }

    public function checkProperty(flag: String, magnitude: Int, ?type: Int) {
        if (!flags.exists(flag)) {
            return false;
        }
        switch (type) {
            case 0: return flags.get(flag) == magnitude;
            case -1: return flags.get(flag) <= magnitude;
            case _: return flags.get(flag) >= magnitude;
        }
    }

    public function setProperty(flag: String, magnitude: Int) {
        this.flags.set(flag, magnitude);
    }

    public function incrementProperty(flag: String, magnitude: Int) {
        if (!flags.exists(flag)) {
            this.flags.set(flag, 0);
        }
        this.flags.set(flag, magnitude + this.flags.get(flag));
    }

}