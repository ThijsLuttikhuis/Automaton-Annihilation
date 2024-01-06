class_name SolarPanel extends Building

func _init():
	energyCost = 100
	resourceCost.add('Iron Plate', 2)
	resourceCost.add('Copper Plate', 3)

func on_ready():
	var gatherSolar = GatherSolarAction.new(1)
	actionQueue.push_back([gatherSolar])

func getDisplayName():
	return "Solar Panel"

