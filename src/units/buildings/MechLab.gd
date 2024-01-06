class_name MechLab extends ConvertResourceBuilding

@onready var placeItemsComponent: PlaceItemsComponent = $"PlaceItemsComponent"

func _init():
	acceptItemsMode = ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL
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
