class_name Furnace extends ConvertResourceBuilding

@onready var placeItemsComponent: PlaceItemsComponent = $"PlaceItemsComponent"

func _init():
	acceptItemsMode = ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL
	energyCost = 200
	resourceCost.add('Stone', 5)

	singleResourceRecipes = {
		"Iron Ore": "Iron Plate",
		"Copper Ore": "Copper Plate"
	}

func getDisplayName():
	return "Furnace"
