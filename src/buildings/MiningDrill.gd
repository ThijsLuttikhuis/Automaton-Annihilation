class_name MiningDrill extends Building

var spaceOccupied: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]

func _init():
	nonBuilableResourceTiles.push_back("Empty")
	
	energyCost = 500
	resourceCost.add('Iron Plate', 12)

func on_ready():
	var gatherResource = MineResourceAction.new(1)
	actionQueue.push_back([gatherResource])

func getDisplayName():
	return "Mining Drill"

func addUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] += 1

func removeUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] -= 1
