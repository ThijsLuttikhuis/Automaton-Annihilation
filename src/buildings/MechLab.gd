class_name MechLab extends ConvertResourceBuilding

func _init():
	energyCost = 200
	resourceCost.add('Stone', 5)

	multiRecipe = Inventory.new()
	multiRecipe.add("Iron Plate", 2)
	multiRecipe.add("Iron Gear", 2)
	
	multiProduct = preload("res://src/units/Architect.tscn")

func getDisplayName():
	return "Mech Lab"
