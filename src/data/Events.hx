package data;

import hxd.Res;
import haxe.Json;

typedef Option = {
    var text: String;
    var consequences: Map<String, Int>;
}

typedef Event = {
    var main: String;
    var opt1: Option;
    var opt2: Option;
}

class Events {
    public var events: Array<Event>;

    public function new() {
        var json = Res.data.test.entry.getText();
        events = Json.parse(json);
        trace(events);
    }

    public function init(): Void {
    
    }

}