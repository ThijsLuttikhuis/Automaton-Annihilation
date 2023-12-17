class_name WorldTileMap extends TileMap

var aStarGrid: AStarGrid2D
var aStarUpdateTime: float = 0.0

func _init():
	aStarGrid = AStarGrid2D.new()
	aStarGrid.region = Rect2i(-200, -200, 400, 400)
	aStarGrid.cell_size = Vector2(16, 16)
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	aStarGrid.jumping_enabled = false
	aStarGrid.update()

func updatePathfinder(cellI, solid):
	aStarGrid.set_point_solid(cellI, solid)
	if aStarGrid.is_dirty():
		aStarGrid.update()
		aStarUpdateTime = $"..".getTime()

func isPointSolid(location: Vector2i):
	return aStarGrid.is_point_solid(location)

func getLastUpdateTime():
	return aStarUpdateTime

func getPath(from: Vector2i, to: Vector2i):
	if isPointSolid(to):
		var dPoints = getNeighbourPointsToTry(to)
		for point in dPoints:
			if !aStarGrid.is_point_solid(point):
				to = point
				break
				
	var pathFound = aStarGrid.get_point_path(from, to)
	for i in range(pathFound.size()):
		pathFound[i] += Vector2(8,8)
	
	return pathFound

func getNeighbourPointsToTry(cell: Vector2i):
	var dPoints: Array[Vector2i] = [
		cell + Vector2i(-1, 0),
		cell + Vector2i(1, 0),
		cell + Vector2i(0, -1),
		cell + Vector2i(0, 1)
		]
	return dPoints
