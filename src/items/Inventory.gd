class_name Inventory

const name2StackSizeDict: Dictionary = {
	'Iron Plate': 50,
	'Iron Ore': 50,
	'Iron Gear': 100,
	'Copper Plate': 50,
	'Copper Ore': 50,
	'Copper Wire': 200,
	'Stone': 50,
	'LimeStone': 50,
	'Coal': 50,
	'Wood Plank': 50,
	'Electronic Circuit': 100,
	'Sand': 200,
	'Cement': 100,
	'Concrete': 100,
	'Water': 100
}

var nSlots: int
var resources: Dictionary

func _init(nSlots_: int = 999):
	nSlots = nSlots_

func remove(resourcesToRemove, number: int = 0):
	var missingSlots = removeTillEmpty(resourcesToRemove, number)
	assert(missingSlots.resources.is_empty(), 'Inventory:error: inventory empty, try to use removeTillEmpty instead')

func removeTillEmpty(resourcesToRemove, number: int = 0):
	if resourcesToRemove is String:
		var inv = Inventory.new(999)
		inv.resources[resourcesToRemove] = number
		resourcesToRemove = inv
	
	assert(resourcesToRemove is Inventory, 'Inventory:error: please input an Inventory or a String / int to remove')
	
	var missingSlots: Inventory = Inventory.new(nSlots)
	
	for key in resourcesToRemove.resources.keys():
		assert(resourcesToRemove.resources[key] > 0, 'Inventory:error: please input resources with positive amounts')
		if resources.has(key):
			if resourcesToRemove.resources[key] > resources[key]:
				missingSlots.resources[key] = resourcesToRemove.resources[key] - resources[key]
				resources[key] = 0
			else:
				resources[key] -= resourcesToRemove.resources[key]
		else:
			missingSlots.resources[key] = resourcesToRemove.resources[key]
	
	removeEmptyResourceSlots()
	return missingSlots

func add(resourcesToAdd, number: int = 0):
	var overflow = addTillFull(resourcesToAdd, number)
	assert(overflow.resources.is_empty(), 'Inventory:error: inventory full, try to use addTillFull instead')

func addTillFull(resourcesToAdd, number: int = 0):
	if resourcesToAdd is String:
		var inv = Inventory.new(999)
		inv.resources[resourcesToAdd] = number
		resourcesToAdd = inv
	
	assert(resourcesToAdd is Inventory, 'Inventory:error: please input an Inventory or a String / int to remove')
	
	var overflow = Inventory.new(999)
	
	for key in resourcesToAdd.resources.keys():
		assert(resourcesToAdd.resources[key] > 0, 'Inventory:error: please input resources with positive amounts')
		if resources.has(key):
			resources[key] += resourcesToAdd.resources[key]
		else:
			resources[key] = resourcesToAdd.resources[key]
	
	removeEmptyResourceSlots()
	return overflow

func getMissingResources(resourcesToCheck, number: int = 0):
	if resourcesToCheck is String:
		var inv = Inventory.new(999)
		inv.resources[resourcesToCheck] = number
		resourcesToCheck = inv
	
	var inventoryCopy = Inventory.deepCopy(self)
	var resourcesToCheckCopy = Inventory.deepCopy(resourcesToCheck)
	
	var temp = resources
	resources = inventoryCopy.resources
	var missingSlots = removeTillEmpty(resourcesToCheckCopy)
	resources = temp
	
	return missingSlots

func hasResources(resourcesToCheck, number: int = 0):
	var missingSlots = getMissingResources(resourcesToCheck, number)
	return missingSlots.resources.is_empty()

func ifHasResourcesRemove(resourcesToRemove, number: int = 0):
	if hasResources(resourcesToRemove, number):
		remove(resourcesToRemove, number)
		return true
	else:
		return false
	
static func deepCopy(inventoryToCopy: Inventory):
	var copy: Inventory = Inventory.new(inventoryToCopy.nSlots)
	copy.add(inventoryToCopy)
	
	return copy

func removeEmptyResourceSlots():
	for key in resources.keys():
		if resources[key] == 0:
			resources.erase(key)

func getFirstItemName():
	if is_empty():
		return null
	else:
		return resources.keys()[0]

func getUniqueItemNames():
	var items: Array[String] = []
	for key in resources.keys():
		items.push_back(key)

func is_empty():
	return resources.is_empty()

func clearResources():
	resources = Dictionary()

func getNumberOfResources(name: String):
	if resources.has(name):
		return resources[name]
	else:
		return 0

func getStackSize(name: String):
	if name2StackSizeDict.has(name):
		return name2StackSizeDict[name]
	else:
		print("Inventory.getStackSize: unknown resource name: " + name)
		return 0
