class_name Windmill extends Building

func _init():
	energyCost = 200
	resourceCost.add('Iron Ore', 8)

func on_ready():
	var gatherWind = GatherWindAction.new(1)
	actionQueue.push_back([gatherWind])

