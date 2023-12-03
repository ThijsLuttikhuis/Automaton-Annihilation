class_name MiningDrill extends Building

func _init():
	nonBuilableResourceTiles.push_back("Empty")
	
	energyCost = 500
	resourceCost.add('Iron Ore', 12)

func on_ready():
	var gatherResource = GatherResourceAction.new(1)
	actionQueue.push_back([gatherResource])

func getDisplayName():
	return "Mining Drill"

