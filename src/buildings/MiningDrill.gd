class_name MiningDrill extends Building

func _init():
	energyCost = 500
	resourceCost.add('Iron Ore', 16)

func on_ready():
	var gatherResource = GatherResourceAction.new(1)
	actionQueue.push_back([gatherResource])

