class_name PlaceItemsComponent extends Node2D

class PlaceItemsMode:
	# in custom mode, higher prio will be checked first
	enum PLACE_ITEMS_MODE {
		ANYWHERE,
		CUSTOM,
		NOWHERE
	}
	
	var mode: PLACE_ITEMS_MODE = PLACE_ITEMS_MODE.ANYWHERE 
	var ChestPrio: int = 2
	var ConveyorPrio: int = 1
	var OtherPrio: int = 0
 
var placeItemsMode: PlaceItemsMode = PlaceItemsMode.new()

var building: Building

var spaceOccupied: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]

func _ready():
	building = $".."
	var inputBuild = building.inputConfigurationList.inputBuild
	inputBuild.push_back(InputConfiguration.new("Place Item Mode"))
	inputBuild.push_back(InputConfiguration.new("Place Chest"))
	inputBuild.push_back(InputConfiguration.new("Place Conveyor"))
	inputBuild.push_back(InputConfiguration.new("Place Other"))

func placeResource(resourceName: String):
	
	var tileMap = building.player.tileMap
	var cellI = tileMap.local_to_map(global_position)
	
	var xDirs = [1, 1, 1, 0, -1, -1, -1, 0]
	var yDirs = [1, 0, -1, -1, -1, 0, 1, 1]
	var dirs = range(8)
	dirs.shuffle()
	
	for i in range(8):
		if spaceOccupied[dirs[i]]:
			continue
		
		var dxI = xDirs[dirs[i]]
		var dyI = yDirs[dirs[i]]
		var neighborCellI = cellI + Vector2i(dxI, dyI)
		var neighborBuilding: Building = building.player.world.getBuildingFromCellI(neighborCellI)
		
		if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.NOWHERE:
			return false
		
		if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE:
			if !neighborBuilding || neighborBuilding.acceptsItems():
				placeDown(resourceName, neighborCellI)
				return true
			return false
		
		# TODO: It's more complicated :)
		continue
	
	return false

func placeDown(resourceName: String, cellI: Vector2i):
	var itemScene = preload("res://src/items/Item.tscn")
	var item = itemScene.instantiate()
	item.setResource(resourceName)
	item.position = building.player.tileMap.map_to_local(cellI)
	building.player.get_node("../Items").add_child(item)

func addUnit(unit: Node2D, pos: int):
	if unit is BuildUnit || unit is Item || unit is Building && unit.acceptsItems():
		spaceOccupied[pos] += 1

func removeUnit(unit: Node2D, pos: int):
	if unit is BuildUnit || unit is Item || unit is Building && unit.acceptsItems():
		spaceOccupied[pos] -= 1
