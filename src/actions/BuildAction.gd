class_name BuildAction extends UnitAction

var moveAction: MoveAction
var ghostBuilding: Unit

func _init(targetPos, ghostBuilding_):
	actionPosition = targetPos
	ghostBuilding = ghostBuilding_
	
func update(unit: Unit, dt):
	var distanceToTargetSquared = (unit.position - actionPosition).length_squared()
	if unit.buildRange * unit.buildRange < distanceToTargetSquared:
		if moveAction && moveAction.actionPosition == actionPosition:
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	else:
		var hasResources = unit.inventory.ifHasResourcesRemove(ghostBuilding.cost)
		if hasResources:
			ghostBuilding.setGhost(false)
			return true
	
	return false
