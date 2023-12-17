class_name MechLab extends ConvertResourceBuilding

func _init():
	energyCost = 500
	resourceCost.add('Stone', 5)
	resourceCost.add('Iron Plate', 5)
	
	multiRecipe = Inventory.new()
	multiRecipe.add("Iron Plate", 2)
	multiRecipe.add("Iron Gear", 2)
	
	multiProduct = load("res://src/units/Architect.tscn")

func getDisplayName():
	return "Mech Lab"
