class_name Windmill extends Building

func _init():
	cost = []
	cost.push_back(InventorySlot.new('Iron Ore', 8))

func on_ready():
	var gatherWind = GatherWindAction.new(position, 1)
	actionQueue.push_back([gatherWind])

