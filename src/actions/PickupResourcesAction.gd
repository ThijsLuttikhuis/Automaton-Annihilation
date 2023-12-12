class_name PickupResourcesAction extends UnitAction

var moveAction: MoveAction
var chest: Unit

var resourcesToPickup: Inventory

var partialPickupAction: PickupResourcesAction

func _init(resourcesToPickup_: Inventory, chest_):
	resourcesToPickup = Inventory.deepCopy(resourcesToPickup_)
	if chest is Chest:
		chest = chest_
		actionPosition = chest.position
	
func update(unit: Unit, dt):
	if unit.inventory.hasResources(resourcesToPickup):
		return true
		
	if partialPickupAction:
		var success = partialPickupAction.update(unit, dt)
		if success:
			partialPickupAction = null
		return false
		
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
		
		var resourcesToPickupCopy = Inventory.deepCopy(resourcesToPickup)
		resourcesToPickupCopy.removeTillEmpty(unit.inventory)
		var hasResources = chest.inventory.ifHasResourcesRemove(resourcesToPickupCopy)
		if hasResources:
			# empty inventory, add required resources, then add inventory back
			var tempInventory = unit.inventory
			unit.inventory = resourcesToPickupCopy
			var overflow = unit.inventory.addTillFull(tempInventory)
			if !overflow.is_empty():
				# unit inventory full, put the excess back in the chest
				chest.inventory.add(overflow)
			chest.openChest()
			
			return true
		
		else:
			# unsuccessful, but still complete action
			return true
	return false

func findChestToPickup(unit: Unit):
	print('no chest input for PickupResourceAction, finding chest...')
	var allChests = unit.player.world.getBuildings("Chest")
	var validChest: Array = []
	
	var missingResources = unit.inventory.getMissingResources(resourcesToPickup)
	for building in allChests:
		if building.inventory.hasResources(missingResources):
			validChest.push_back(building)
			
	if validChest.is_empty():
		splitResourcePickup(unit)
		return false
	
	chest = validChest[0]
	for building in validChest:
		if (chest.position - unit.position).length_squared() > (building.position - unit.position).length_squared():
			chest = building
	
	actionPosition = chest.position
	return true

func splitResourcePickup(unit: Unit):
	var allChests = unit.player.world.getBuildings("Chest")
	var missingResources = unit.inventory.getMissingResources(resourcesToPickup)
	
	for building in allChests:
		var stillMissing = building.inventory.getMissingResources(missingResources)
		if !stillMissing.hasResources(missingResources):
			# stillMissing is smaller than resourcesToPickup, therefore chest has some items required
			missingResources.remove(stillMissing)
			partialPickupAction = PickupResourcesAction.new(missingResources, building)
			return
