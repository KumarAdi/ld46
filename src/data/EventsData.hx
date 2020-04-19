package data;

import hxd.Res;
import haxe.Json;

typedef ConsequenceData = {
    var flag: String;
    var magnitude: Int;
}

typedef OptionData = {
    var text: String;
    var consequences: Array<ConsequenceData>;
}

typedef EventData = {
    var main: String;
    var opt1: OptionData;
    var opt2: OptionData;
}

class EventsData {
    public var events: Array<EventData>;

    public function new() {
        var json = Res.data.test.entry.getText();
        events = Json.parse(json);
    }

    public function init(): Void {
    
    }

}