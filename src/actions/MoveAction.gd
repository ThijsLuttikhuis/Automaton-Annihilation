class_name MoveAction extends UnitAction

const DISTANCE_THRESHOLD = 5

var navigationAgent: NavigationAgent2D

func _init(targetPos):
	actionPosition = targetPos
	
func update(unit: Unit, _dt):
	if unit.targetPosition == actionPosition && unit.isNavigationFinished():
		unit.velocity = Vector2(0,0)
		return true
	
	unit.targetPosition = actionPosition
	return false
