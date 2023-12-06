class_name Chest extends Building

func _init():
	energyCost = 250
	resourceCost.add('Iron Ore', 5)
	
	inventory = Inventory.new(20)
	
func on_ready():
	pass

func getDisplayName():
	return "Chest"

func pickupUnit(unit):
	if unit is Item:
		var problemAddingItem = inventory.addTillFull(unit.resourceName, 1)
		if problemAddingItem.resources.is_empty():
			unit.queue_free()
			
	print('chest entered')
