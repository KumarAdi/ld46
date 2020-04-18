package data;

import haxe.ds.HashMap;

class Player {
    public var flags: Map<String, Int>;

    // private var items
    // private var companions

    public function new() {
        flags = new Map<>();
        flags.set("curse", 1);
        flags.set("supplies", 3);
        flags.set("money", 3);
    }

    public function init(): Void {
    
    }

}