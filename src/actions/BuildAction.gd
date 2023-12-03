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
		unit.velocity = Vector2(0,0)
		
		var cellI = unit.player.tileMap.local_to_map(actionPosition)
		if !ghostBuilding.canBuildOnTile(cellI):
			ghostBuilding.queue_free() # cancel
			return true
		
		var energy = unit.player.world.getEnergy()
		var hasEnergy = energy >= ghostBuilding.energyCost 
		if hasEnergy:
			var hasResources = unit.inventory.ifHasResourcesRemove(ghostBuilding.resourceCost)
			if hasResources:
				unit.player.world.removeEnergy(ghostBuilding.energyCost)
				ghostBuilding.setGhost(false)
				unit.player.tileMap.set_cell(2, cellI, 2, ghostBuilding.toTileMapAtlasCoords())
				return true
	
	return false

func clear():
	if ghostBuilding.isGhost():
		ghostBuilding.queue_free()
