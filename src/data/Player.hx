package data;

import haxe.ds.HashMap;

class Player {
    public var flags: Map<String, Int>;

    //private var items
    //private var companions

    public function new() {
        flags = new HashMap<>();
        flags.put("curse", 1);
        flags.put("supplies", 3);
        flags.put("money", 3);
    }

    public function init(): Void {
    
    }

}