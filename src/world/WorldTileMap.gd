class_name WorldTileMap extends TileMap

@onready var world: World = $".."

const MAX_IMPOSSIBLE_PATHS_STORED: int = 50

var aStarGrid: AStarGrid2D
var aStarUpdateTime: float = 0.0

var impossiblePaths: Dictionary = {}

func _init():
	aStarGrid = AStarGrid2D.new()
	aStarGrid.region = Rect2i(-200, -200, 400, 400)
	aStarGrid.cell_size = Vector2(16, 16)
	aStarGrid.offset = aStarGrid.cell_size * 0.5
	aStarGrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
	aStarGrid.jumping_enabled = false
	aStarGrid.update()

func getBuildingFromCell(cellI):
	var cellData = get_cell_tile_data(2, cellI)
	if !cellData:
		return null
	var buildingName = cellData.get_custom_data("buildingName")
	for building in world.getBuildings(buildingName):
		if cellI == local_to_map(building.position):
			return building
	
	return null

func updatePathfinder(cellI, solid):
	aStarGrid.set_point_solid(cellI, solid)
	if aStarGrid.is_dirty():
		aStarGrid.update()
		aStarUpdateTime = world.getTime()
		impossiblePaths = {}

func isPointSolid(location: Vector2i):
	return aStarGrid.is_point_solid(location)

func getLastUpdateTime():
	return aStarUpdateTime

func getPath(unit: Unit, from: Vector2i, to: Vector2i):
	if isImpossiblePath(unit, to):
		return []
	
	if isPointSolid(to):
		var dPoints = getNeighbourPointsToTry(to)
		for point in dPoints:
			if !aStarGrid.is_point_solid(point):
				to = point
				break
				
	var pathFound = aStarGrid.get_point_path(from, to)
	if pathFound.is_empty():
		addImpossiblePath(unit, to)
	
	return pathFound

func getNeighbourPointsToTry(cell: Vector2i):
	var dPoints: Array[Vector2i] = [
		cell + Vector2i(-1, 0),
		cell + Vector2i(1, 0),
		cell + Vector2i(0, -1),
		cell + Vector2i(0, 1)
		]
	return dPoints

func addImpossiblePath(unit: Unit, to: Vector2i):
	if impossiblePaths.has(unit):
		impossiblePaths[unit].push_back(to)
	else:
		impossiblePaths[unit] = [to]

func isImpossiblePath(unit: Unit, to: Vector2i):
	if impossiblePaths.has(unit):
		var unitPaths = impossiblePaths[unit]
		if unitPaths.size() > MAX_IMPOSSIBLE_PATHS_STORED:
			unitPaths.erase(impossiblePaths[0])
		
		for path in unitPaths:
			if path == to:
				return true
	
	return false
