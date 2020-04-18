package scenes;

import h2d.Scene;

interface Level {
    public var scene: Scene;
    public function init(): Void;
    public function update(dt:Float):Null<Level>;
}