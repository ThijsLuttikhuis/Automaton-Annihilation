class_name MoveAction extends UnitAction

const DISTANCE_THRESHOLD = 3.1
func _init(targetPos):
	actionPosition = targetPos
	
func update(unit: Unit, _dt):
	var deltaPos = actionPosition - unit.position;
	if deltaPos.length_squared() < DISTANCE_THRESHOLD * DISTANCE_THRESHOLD:
		actionPosition = unit.position
		unit.velocity = Vector2(0,0)
		return true
	else:
		unit.velocity = deltaPos.normalized() * unit.moveSpeed
		return false
