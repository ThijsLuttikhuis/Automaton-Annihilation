class_name Windmill extends Building

func _init():
	energyCost = 200
	resourceCost.add('Iron Plate', 3)
	resourceCost.add('Iron Plate', 3) # to be iron gear
	
func on_ready():
	var gatherWind = GatherWindAction.new(1)
	actionQueue.push_back([gatherWind])

func getDisplayName():
	return "Windmill"
