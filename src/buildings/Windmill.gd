class_name Windmill extends Building

func on_ready():
	var gatherWind = GatherWindAction.new(position, 1)
	actionQueue.push_back([gatherWind])

