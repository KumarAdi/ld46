package data;

import hxd.Res;
import haxe.Json;

typedef FlagData = {
    var flag: String;
    var magnitude: Int;
}

typedef OptionData = {
    var text: String;
    var nextid: String;
    var requirements: Array<FlagData>;
    var consequences: Array<FlagData>;
}

typedef PassageData = {
    var text: String;
    var options: Array<OptionData>;
}

typedef EventData = {
    var scenarioid: Int;
    var passages: Map<String, PassageData>;
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