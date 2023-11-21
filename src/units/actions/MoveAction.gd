class_name MoveAction extends UnitAction

func _init(targetPos):
	typeName = "MoveAction"
	actionPosition = targetPos
	
func update(unit: Unit):
	var deltaPos = actionPosition - unit.position;
	if deltaPos.length_squared() < 10:
		actionPosition = unit.position
		unit.velocity = Vector2(0,0)
		return true
	else:
		unit.velocity = deltaPos.normalized() * unit.moveSpeed
		return false
	
	
	
	
