class_name DemolishAction extends UnitAction

var moveAction: MoveAction
var ghostBuilding: Unit

func _init(targetPos, ghostBuilding_):
	actionPosition = targetPos
	ghostBuilding = ghostBuilding_

func update(unit: Unit, dt):
	if unit.buildRange * unit.buildRange < (unit.position - actionPosition).length_squared():
		if moveAction && moveAction.actionPosition == actionPosition:
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	else:
		var tileMap = unit.player.tileMap
		unit.velocity = Vector2(0,0)
		unit.targetPosition = Vector2(9e9, 9e9)
		
		var cellI = tileMap.local_to_map(actionPosition)
		var building = tileMap.getBuildingFromCell(cellI)
		if !building:
			return true
		
		tileMap.set_cell(2, cellI)
		tileMap.updatePathfinder(cellI, false)
		building.demolish()
		return true
	
	return false

func clear():
	if ghostBuilding.isGhost():
		ghostBuilding.queue_free()
