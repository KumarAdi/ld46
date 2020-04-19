package data;

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

typedef EventsData = {
    var eventsData: Array<Event>;
}

class Events {
    public var events: EventsData;

    public function new(json: String) {
        events = Json.parse(json);
        trace(events);
    }

    public function init(): Void {
    
    }

}