package data;

import haxe.ds.HashMap;

class PlayerData {
    private static var instance: PlayerData;
    public var flags: Map<String, Int>;

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

}