package data;

import haxe.Json;

class Events {
    public var events: Array<Map>;

    public function new(json: Json) {
        events = haxe.JSON.parse(json);
    }

    public function init(): Void {
    
    }

}