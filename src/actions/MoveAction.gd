class_name MoveAction extends UnitAction

const DISTANCE_THRESHOLD = 5

var testLine: Node2D
var pathFound
var pathIndex: int = 1
var pathUpdateTime: float = 0.0

func _init(targetPos):
	actionPosition = targetPos
	
func update(unit: Unit, _dt):
	if !testLine:
		testLine = unit.get_node("ActionQueue/LineTestCollision/CollisionShape2D")
	
	updateTestLinePosition(unit)
	
	if !isPathClear(unit):
		updatePathfinder(unit)
	else:
		unit.targetPosition = actionPosition
	
	if unit.targetPosition == actionPosition && unit.isNavigationFinished():
		unit.velocity = Vector2(0,0)
		return true
		
	return false
	
func updateTestLinePosition(unit: Unit):
	var startPos = unit.position
	var endPos = actionPosition
	var unitHitbox = unit.get_node("CollisionShape2D")
	
	var capsule = testLine
	capsule.shape.radius = unitHitbox.shape.radius
	capsule.shape.height = (endPos - startPos).length()
	capsule.position = (endPos + startPos) * 0.5
	capsule.rotation = PI * 0.5 + atan2(endPos.y - startPos.y, endPos.x - startPos.x)

func isPathClear(unit):
	var tileMap: WorldTileMap = unit.player.tileMap

	var targetCellPos = tileMap.local_to_map(actionPosition)
	if tileMap.pathfinder.isPointSolid(targetCellPos):
		return unit.actionQueue.lineTestCollisionCount < 3
	else:
		return unit.actionQueue.lineTestCollisionCount < 2

func updatePathfinder(unit: Unit):
	var tileMap: TileMap = unit.player.tileMap
	
	var unitCellPos = tileMap.local_to_map(unit.position)
	var targetCellPos = tileMap.local_to_map(actionPosition)
	
	if !pathFound || \
		tileMap.local_to_map(pathFound[-1]) != targetCellPos || \
		tileMap.pathfinder.getLastUpdateTime() >= pathUpdateTime:
		
		pathFound = tileMap.pathfinder.getPath(unit, unitCellPos, targetCellPos)
		pathIndex = 1
		pathUpdateTime = unit.player.world.getTime()
	
	if pathIndex >= pathFound.size():
		unit.targetPosition = actionPosition
		return
		
	# hack actionQueue line to show pathFound
	#unit.actionQueue.line.clear_points()
	#for point in pathFound:
		#unit.actionQueue.line.add_point(point)
	
	unit.targetPosition = pathFound[pathIndex]
	if unit.isNavigationFinished():
		pathIndex += 1

func getCellOccupied(tileMap: TileMap, cellPos: Vector2i):
	var tile = tileMap.get_cell_tile_data(2, cellPos)
	return tile.get_custom_data("blockPathfinding")
