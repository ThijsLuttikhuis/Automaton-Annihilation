class_name BuildAction extends UnitAction

var pickupResourcesAction: PickupResourcesAction
var moveAction: MoveAction
var ghostBuilding: Unit

func _init(targetPos, ghostBuilding_):
	actionPosition = targetPos
	ghostBuilding = ghostBuilding_

func update(unit: Unit, dt):
	if pickupResourcesAction:
		var success = pickupResourcesAction.update(unit, dt)
		if success:
			pickupResourcesAction.clear()
			pickupResourcesAction = null
	elif unit.buildRange * unit.buildRange < (unit.position - actionPosition).length_squared():
		if moveAction && moveAction.actionPosition == actionPosition:
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	else:
		unit.velocity = Vector2(0,0)
		unit.targetPosition = Vector2(9e9, 9e9)
		
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
				ghostBuilding.reparent(ghostBuilding.get_node("../../Buildings"))
				unit.player.tileMap.set_cell(2, cellI, 2, ghostBuilding.toTileMapAtlasCoords())
				unit.player.tileMap.updatePathfinder(cellI, true)
				return true
				
			else:
				pickupResourcesAction = PickupResourcesAction.new(ghostBuilding.resourceCost, false)
				
	return false

func clear():
	if ghostBuilding.isGhost():
		ghostBuilding.queue_free()
