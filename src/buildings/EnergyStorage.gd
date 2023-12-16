class_name EnergyStorage extends Building

func _init():
	energyStorage = 3000

	energyCost = 200
	resourceCost.add('Iron Plate', 2)
	resourceCost.add('Copper Plate', 5) # to be copper wire

func on_ready():
	var gatherWind = GatherWindAction.new(1)
	actionQueue.push_back([gatherWind])

func getDisplayName():
	return "Energy Storage"
