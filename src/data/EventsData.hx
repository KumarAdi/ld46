package data;

import hxd.Res;
import haxe.Json;

typedef FlagData = {
    var flag: String;
    var magnitude: Int;
    var probability: Int;
}

typedef OptionData = {
    var text: String;
    var nextid: String;
    var requirements: Array<FlagData>;
    var consequences: Array<FlagData>;
}

typedef PassageData = {
    var id: String;
    var text: String;
    var options: Array<OptionData>;
}

typedef EventData = {
    var scenarioid: Int;
    var passages: Array<PassageData>;
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