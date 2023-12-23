class_name MechLab extends ConvertResourceBuilding

func _init():
	energyCost = 500
	resourceCost.add('Stone', 5)
	resourceCost.add('Iron Plate', 5)
	
	var inputRecipe = Inventory.new()
	inputRecipe.add("Iron Plate", 2)
	inputRecipe.add("Iron Gear", 2)
	var product = load("res://src/units/allied_units/Architect.tscn")
	recipe = Recipe.new(inputRecipe, product)

func getDisplayName():
	return "Mech Lab"
