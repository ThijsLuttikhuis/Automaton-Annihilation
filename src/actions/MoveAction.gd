class_name MoveAction extends UnitAction

const DISTANCE_THRESHOLD := 5.0
const MOVE_AWAY_DISTANCE := 12.0

var testLine: Node2D
var pathFound: PackedVector2Array = []
var pathIndex: int = 1
var pathUpdateTime: float = 0.0

func _init(targetPos):
	actionPosition = targetPos
	
func update(unit: Unit, _dt):
	if !testLine:
		testLine = unit.get_node("ActionQueue/LineTestCollision/CollisionShape2D")
	
	updateTestLinePosition(unit)
	
	if isPathClear(unit):
		unit.targetPosition = actionPosition
	else:
		var closestUnitOnLine := getClosestMoveUnitOnTestLine(unit)
		var distanceToClosestUnitSquared = (closestUnitOnLine.position - unit.position).length_squared()
		var avoidanceMargin = 1.2
		var avoidDistance = (unit.get_node("CollisionShape2D").shape.radius + closestUnitOnLine.get_node("CollisionShape2D").shape.radius) * avoidanceMargin
		if closestUnitOnLine != unit && distanceToClosestUnitSquared < avoidDistance * avoidDistance:
			var actionPosDir = (actionPosition - unit.position)
			unit.targetPosition = unit.position + actionPosDir.rotated(deg_to_rad(90))
			var moveAwayDistance = MOVE_AWAY_DISTANCE
			closestUnitOnLine.pleaseMoveAwayFrom(unit, moveAwayDistance)
		else:
			updatePathfinder(unit)
	
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

func getClosestMoveUnitOnTestLine(unit: Unit) -> Unit:
	var unitsOnLine = unit.actionQueue.lineTestCollisionUnits
	var closestUnit = unit
	for unitOnLine in unitsOnLine:
		if unitOnLine is MoveUnit && unit != unitOnLine && (closestUnit == unit || \
			unitOnLine.position.distance_squared_to(unit.position) < closestUnit.position.distance_squared_to(unit.position)):
			
			closestUnit = unitOnLine
	return closestUnit

func isPathClear(unit):
	var tileMap: WorldTileMap = unit.player.tileMap
	
	var targetCellPos = tileMap.local_to_map(actionPosition)
	if tileMap.pathfinder.isPointSolid(targetCellPos):
		return unit.actionQueue.lineTestCollisionCount < 3
	else:
		return unit.actionQueue.lineTestCollisionCount < 2

func updatePathfinder(unit: Unit):
	var tileMap: TileMap = unit.player.tileMap
	var pathfinder: Pathfinder = tileMap.pathfinder
	
	var unitCellPos = tileMap.local_to_map(unit.position)
	var targetCellPos = tileMap.local_to_map(actionPosition)
	
	var oldPathFound := pathFound
	pathFound = pathfinder.getPath(unit, unitCellPos, targetCellPos)
	if oldPathFound != pathFound:
		pathIndex = 1

	pathUpdateTime = unit.player.world.getTime()
	
	if pathIndex >= pathFound.size():
		unit.targetPosition = actionPosition
		return
		
	# hack actionQueue line to show pathFound
	unit.actionQueue.line.clear_points()
	for point in pathFound:
		unit.actionQueue.line.add_point(point)
	
	unit.targetPosition = pathFound[pathIndex]
	if unit.isNavigationFinished():
		pathIndex += 1

func getCellOccupied(tileMap: TileMap, cellPos: Vector2i):
	var tile = tileMap.get_cell_tile_data(2, cellPos)
	return tile.get_custom_data("blockPathfinding")
