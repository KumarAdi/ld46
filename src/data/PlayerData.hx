package data;

import haxe.ds.HashMap;

class PlayerData {
    private static var instance: PlayerData;
    private var flags: Map<String, Int>;

    private function new() {
        flags = new Map();
        flags.set("curse", 30);
        flags.set("supplies", 8);
        flags.set("money", 250);
        flags.set("heartstone", 0);
        flags.set("orb", 0);
        flags.set("cop", 0);
        flags.set("mary", 0);
        flags.set("james", 0);
        flags.set("margaret", 0);
        flags.set("geiger", 0);
    }

    public static function getInstance(): PlayerData {
        if (instance == null) {
            instance = new PlayerData();
        }

        return instance;
    }

    public static function resetInstance() {
        instance = new PlayerData();
    }

    public function checkProperty(flag: String, magnitude: Int, ?checkType: Int) {
        if (!flags.exists(flag)) {
            return false;
        }
        switch (checkType) {
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

    public function getProperty(flag: String) {
        return this.flags.get(flag);
    }

}