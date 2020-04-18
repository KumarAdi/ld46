package data;

import h2d.col.Bounds;
import h2d.col.Point;

class MapData {
    private final minDistance: Float;
    private final dims: Bounds;
    public var towns: Array<Point>;

    public function new(minDistance: Float, dims: Bounds) {
        this.minDistance = minDistance;
        this.dims = dims;
        this.towns = generatePoints();
    }

    private function generatePoints(): Array<Point> {
        var cellSize = minDistance / Math.sqrt(2);
        var sceneSize = dims.getMax().sub(dims.getMin());
        var gridDims = sceneSize.scale(1/cellSize);

        var grid = [for (x in 0...Math.ceil(gridDims.x)) 
            [for (y in 0...Math.ceil(gridDims.y)) 
                false
            ]
        ];

        var points = new Array<Point>();
        var spawnPoints = new Array<Point>();

        var firstPoint = getRandomPoint();

        points.push(firstPoint);
        spawnPoints.push(firstPoint);

        while (spawnPoints.length > 0) {
            var spawnIdx = Math.floor(Math.random() * spawnPoints.length);
            var spawnPoint = spawnPoints[spawnIdx];

            var foundCandidate = false;

            for (x in 0...45) {
                var r = Math.random() * minDistance + minDistance;
                var theta = Math.random() * 2 * Math.PI;

                var candidate = new Point(
                    r * Math.cos(theta),
                    r * Math.sin(theta)
                ).add(spawnPoint);

                if (!dims.contains(candidate)) {
                    break;
                }

                var gridPoint = screenToGrid(candidate, cellSize);
                if (isValid(gridPoint, grid)) {
                    foundCandidate = true;
                    points.push(candidate);
                    spawnPoints.push(candidate);
                    grid[Math.floor(gridPoint.x)][Math.floor(gridPoint.y)] = true;
                    break;
                }
            }

            if (!foundCandidate) {
                spawnPoints.remove(spawnPoint);
            }
        }

        return points;
    }

    private function getRandomPoint(): Point {
        var sceneSize = dims.getMax().sub(dims.getMin());
        return new Point(
            Math.random() * sceneSize.x,
            Math.random() * sceneSize.y
        ).add(dims.getMin());
    }

    private function isValid(gridPoint: Point, grid:Array<Array<Bool>>): Bool {
        var xMin = Math.ceil(Math.max(gridPoint.x - 2, 0));
        var xMax = Math.ceil(Math.min(gridPoint.x + 2, grid.length - 1));
        var yMin = Math.ceil(Math.max(gridPoint.y - 2, 0));
        var yMax = Math.ceil(Math.min(gridPoint.y + 2, grid[0].length - 1));
        for (x in xMin...xMax) {
            for (y in yMin...yMax) {
                if (grid[x][y]) {
                    return false;
                }
            }
        }

        return true;
    }

    private inline function screenToGrid(point: Point, cellSize: Float): Point {
        return point.sub(dims.getMin()).scale(1/cellSize);
    }
}