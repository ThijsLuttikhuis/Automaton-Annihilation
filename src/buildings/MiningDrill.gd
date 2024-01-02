class_name MiningDrill extends Building

@onready var placeItemsComponent: PlaceItemsComponent = $"PlaceItemsComponent"

func _init():
	nonBuilableResourceTiles.push_back("Empty")
	
	energyCost = 500
	resourceCost.add('Iron Plate', 10)

func on_ready():
	var gatherResource = MineResourceAction.new(1)
	actionQueue.push_back([gatherResource])

func getDisplayName():
	return "Mining Drill"
