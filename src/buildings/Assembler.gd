class_name Assembler extends ConvertResourceBuilding

func _init():
	energyCost = 200
	resourceCost.add('Stone', 5)

	multiRecipe = Inventory.new()
	multiRecipe.add("Iron Plate", 2)
	
	multiProduct = Inventory.new()
	multiProduct.add("Iron Gear", 4)
	
	duration = 2.0

func getDisplayName():
	return "Assembler"
