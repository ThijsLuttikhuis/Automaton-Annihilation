class_name ConvertResourceBuilding extends Building

var duration: float = 1.0

var singleResourceRecipes: Dictionary

var multiRecipe: Inventory
var multiProduct

var spaceOccupied: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]

func on_physics_process(_dt):
	if actionQueue.actionsEmpty():
		$"Sprite2D".set_frame(0)
		if !inventory.is_empty():
			tryConvertMultiRecipe()

func addUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] += 1

func removeUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] -= 1

func pickupUnit(unit):
	if ghost:
		return
	if unit is Item:
		if isConvertable(unit):
			var problemAddingItem = inventory.addTillFull(unit.resourceName, 1)
			if problemAddingItem.resources.is_empty():
				tryConvertSingleItem(unit)
				unit.queue_free()

func isConvertable(itemName):
	if itemName is Item:
		itemName = itemName.resourceName
	assert(itemName is String, 'ConvertResourceBuilding:isConvertable: itemName should be an Item or a String')
	
	for key in singleResourceRecipes.keys():
		if key == itemName:
			return true
	
	if multiRecipe && multiRecipe.hasResources(itemName, 1):
		return true
		
	return false

func tryConvertSingleItem(item: Item):
	for key in singleResourceRecipes.keys():
		if key == item.resourceName:
			var recipe = Inventory.new()
			recipe.add(item.resourceName, 1)
			var product = Inventory.new()
			product.add(singleResourceRecipes[key], 1)
			
			var action = ConvertResourceAction.new(recipe, product, duration)
			actionQueue.push_back([action])
			
			return true
	
	return false

func tryConvertMultiRecipe():
	if inventory.hasResources(multiRecipe):
		var action = ConvertResourceAction.new(multiRecipe, multiProduct, duration)
		actionQueue.push_back([action])

func getProductFromResources(resources):
	if resources is Item:
		resources = resources.resourceName
		
	if resources is String:
		for key in singleResourceRecipes.keys():
			if key == resources:
				return singleResourceRecipes[key]
	
	if resources is String:
		var inv = Inventory.new()
		inv.add(resources, 1)
		resources = inv
	assert(resources is Inventory, 'ConvertResourceBuilding:isConvertable: itemName should be an Inventory, Item or a String')
	
	if multiRecipe && resources.hasResources(multiRecipe):
		return multiProduct
