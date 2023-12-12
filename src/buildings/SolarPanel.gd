class_name SolarPanel extends Building

func _init():
	energyCost = 100
	resourceCost.add('Iron Ore', 9)

func on_ready():
	var gatherSolar = GatherSolarAction.new(1)
	actionQueue.push_back([gatherSolar])

func getDisplayName():
	return "Solar Panel"

