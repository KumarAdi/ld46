package data;

import haxe.Json;

class Events {
    public var events: Dynamic;

    public function new(json: String) {
        events = Json.parse(json);
    }

    public function init(): Void {
    
    }

}