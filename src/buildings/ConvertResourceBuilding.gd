class_name ConvertResourceBuilding extends Building

var duration: float = 1.0

var singleResourceRecipes: Dictionary
var recipe: Recipe

var spaceOccupied: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]
var pickupArea: Array[Item] = []

func _init():
	acceptItemsMode = ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL

func on_physics_process(dt):
	if actionQueue.actionsEmpty():
		$"Sprite2D".set_frame(0)
		if !inventory.is_empty():
			tryConvertMultiRecipe()
	
	on2_physics_process(dt)

func on2_physics_process(_dt):
	pass # can be overwritten

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
		if acceptsItem(unit.resourceName):
			var problemAddingItem = inventory.addTillFull(unit.resourceName, 1)
			if problemAddingItem.resources.is_empty():
				tryConvertSingleItem(unit)
				unit.queue_free()
		else:
			pickupArea.push_back(unit)

func isConvertable(itemName):
	if itemName is Item:
		itemName = itemName.resourceName
	assert(itemName is String, 'ConvertResourceBuilding:isConvertable: itemName should be an Item or a String')
	
	for key in singleResourceRecipes.keys():
		if key == itemName:
			return true
	
	if !recipe || !recipe.inputRecipe:
		return false
	
	return recipe.inputRecipe.hasResources(itemName, 1)

func tryConvertSingleItem(item: Item):
	for key in singleResourceRecipes.keys():
		if key == item.resourceName:
			var inputRecipe = Inventory.new()
			inputRecipe.add(item.resourceName, 1)
			var product = Inventory.new()
			product.add(singleResourceRecipes[key], 1)
			var singleRecipe: Recipe = Recipe.new(inputRecipe, product)
			var action = ConvertResourceAction.new(singleRecipe, duration)
			actionQueue.push_back([action])
			
			return true
	
	return false

func tryConvertMultiRecipe():
	if inventory.hasResources(recipe.inputRecipe):
		var action = ConvertResourceAction.new(recipe, duration)
		actionQueue.push_back([action])

func getProductFromResources(resources):
	# if not Inventory try convert Item -> String -> Inventory
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
	
	if recipe && resources.hasResources(recipe.inputRecipe):
		return recipe
	
	return null

func acceptsItem(resourceName: String):
	if acceptItemsMode == ACCEPT_ITEMS_MODE.NEVER:
		return false
	
	if !isConvertable(resourceName):
		return false
	
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS:
		return true
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_EMPTY:
		return inventory.is_empty()
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL:
		return !inventory.is_full()
