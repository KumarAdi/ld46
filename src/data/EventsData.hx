package data;

import hxd.Res;
import haxe.Json;

typedef FlagData = {
    var flag: String;
    var magnitude: Int;
    //var lessThan: Bool; // for requirements, default is greater than or equal to, set to true for less than
}

typedef OutcomeData= {
    var nextid: String;
    var consequences: Array<FlagData>;
    var probability: Null<Float>; // is one outcome in the outcomes array has a probability, then all should have it
}

typedef OptionData = {
    var text: String;
    var requirements: Array<FlagData>;
    var outcomes: Array<OutcomeData>;
}

typedef PassageData = {
    var id: String;
    var text: String;
    var options: Array<OptionData>;
}

typedef EventData = {
    var scenarioid: Int;
    var scenarioreq: Array<FlagData>;
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