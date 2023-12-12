class_name EnergyStorage extends Building

func _init():
	energyStorage = 3000
	
	energyCost = 200
	resourceCost.add('Iron Ore', 2)
	resourceCost.add('Copper Ore', 5)

func on_ready():
	var gatherWind = GatherWindAction.new(1)
	actionQueue.push_back([gatherWind])

func getDisplayName():
	return "Energy Storage"
