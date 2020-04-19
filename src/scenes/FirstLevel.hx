package scenes;

class FirstLevel extends MapSelectLevel {
    public function new(parent: Level) {
        super(parent);

        // launch dialouge right when map opens up too
        nextLevel = new DialogueLevel(this, eventData, playerData, 0);
    }
}