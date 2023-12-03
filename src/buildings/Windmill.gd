class_name Windmill extends Building

func _init():
	energyCost = 200
	resourceCost.add('Iron Ore', 6)

func on_ready():
	var gatherWind = GatherWindAction.new(1)
	actionQueue.push_back([gatherWind])

func getDisplayName():
	return "Windmill"
	
