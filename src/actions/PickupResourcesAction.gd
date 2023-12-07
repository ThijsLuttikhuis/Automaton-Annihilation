class_name PickupResourcesAction extends UnitAction

var moveAction: MoveAction
var chest: Unit

var resourcesToPickup: Inventory

func _init(resourcesToPickup_: Inventory, chest_):
	resourcesToPickup = Inventory.deepCopy(resourcesToPickup_)
	if chest is Chest:
		chest = chest_
		actionPosition = chest.position
	
func update(unit: Unit, dt):
	if !(chest is Chest):
		var chestFound = findChestToPickup(unit)
		if !chestFound:
			return
	
	var distanceToTargetSquared = (unit.position - actionPosition).length_squared()
	if unit.buildRange * unit.buildRange < distanceToTargetSquared:
		if moveAction && moveAction.actionPosition == actionPosition:
			moveAction.update(unit, dt)
		else:
			moveAction = MoveAction.new(actionPosition)
	else:
		unit.velocity = Vector2(0,0)
		if chest.is_queued_for_deletion():
			return true
		
		var hasResources = chest.inventory.ifHasResourcesRemove(resourcesToPickup)
		if hasResources:
			# empty inventory, add required resources, then add inventory back
			var tempInventory = unit.inventory
			unit.inventory = resourcesToPickup
			var overflow = unit.inventory.addTillFull(tempInventory)
			if !overflow.is_empty():
				# unit inventory full, put the excess back in the chest
				chest.inventory.add(overflow)
			chest.openChest()
				
			return true
	
	return false

func findChestToPickup(unit):
	print('no chest input for PickupResourceAction, finding chest...')
	var allBuildings = unit.player.world.get_node("Buildings")
	for building in allBuildings.get_children():
		if building is Chest:
			if building.inventory.hasResources(resourcesToPickup):
				chest = building
				actionPosition = chest.position
				return true
	
	return false #no chest found
