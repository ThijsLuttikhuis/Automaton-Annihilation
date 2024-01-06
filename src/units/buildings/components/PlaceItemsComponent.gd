class_name PlaceItemsComponent extends Node2D

class PlaceItemsMode:
	# in custom mode, higher prio will be checked first
	enum PLACE_ITEMS_MODE {
		ANYWHERE,
		CUSTOM,
		DISABLED
	}
	
	var mode := PLACE_ITEMS_MODE.ANYWHERE
	var chestPrio := 2
	var conveyorPrio := 1
	var otherPrio := 0
 
var placeItemsMode := PlaceItemsMode.new()

var building: Building

var spaceOccupied := [0, 0, 0, 0, 0, 0, 0, 0]

func _ready():
	building = $".."
	var inputBuild = building.inputConfigurationList.inputBuild
	inputBuild.push_back(InputConfiguration.new("Place Items"))
	inputBuild.push_back(InputConfiguration.new("Chest Prio"))
	inputBuild.push_back(InputConfiguration.new("Conveyor Prio"))
	inputBuild.push_back(InputConfiguration.new("Other Prio"))

func placeResource(resourceName: String) -> bool:
	updatePlaceItemsMode()
	
	var tileMap = building.player.tileMap
	var cellI = tileMap.local_to_map(global_position)
	
	var xDirs = [1, 1, 1, 0, -1, -1, -1, 0]
	var yDirs = [1, 0, -1, -1, -1, 0, 1, 1]
	var dirs = range(8)
	dirs.shuffle()
	
	for prioI in [2, 1, 0]:
		if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM &&\
			!placeItemsMode.chestPrio == prioI &&\
			!placeItemsMode.conveyorPrio == prioI &&\
			!placeItemsMode.otherPrio == prioI:
			
			continue # skip inner for if there is no config with correct prio
		
		if prioI != 2 &&\
			(placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE ||\
			placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.DISABLED):
			
			return false # prio is irrelevant if placeitemsmode is not custom
			
		for i in range(8):
			if spaceOccupied[dirs[i]]:
				continue
			
			var dxI = xDirs[dirs[i]]
			var dyI = yDirs[dirs[i]]
			var neighborCellI = cellI + Vector2i(dxI, dyI)
			var neighborBuilding := building.player.world.getBuildingFromCellI(neighborCellI)
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.DISABLED:
				return false
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE:
				if !neighborBuilding || neighborBuilding.acceptsItem(resourceName):
					placeDown(resourceName, neighborCellI)
					return true
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM:
				var canBuild = false
				if neighborBuilding && neighborBuilding.pickupItemsComponent.acceptsItem(resourceName):
					canBuild = canBuild || (placeItemsMode.chestPrio == prioI && neighborBuilding.getDisplayName() == "Chest")
					canBuild = canBuild || (placeItemsMode.conveyorPrio == prioI && neighborBuilding.getDisplayName() == "Conveyor Belt")
					canBuild = canBuild || (placeItemsMode.otherPrio == prioI && neighborBuilding.getDisplayName() != "Chest" && neighborBuilding.getDisplayName() != "Conveyor Belt")
				
				if canBuild:
					placeDown(resourceName, neighborCellI)
					return true
	
	if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM:
		for i in range(8):
			if spaceOccupied[dirs[i]]:
				continue
				
			var dxI = xDirs[dirs[i]]
			var dyI = yDirs[dirs[i]]
			var neighborCellI = cellI + Vector2i(dxI, dyI)
			var neighborBuilding: Building = building.player.world.getBuildingFromCellI(neighborCellI)
			
			if !neighborBuilding:
				placeDown(resourceName, neighborCellI)
				return true
	
	return false

func placeDown(resourceName: String, cellI: Vector2i):
	var itemScene = preload("res://src/items/Item.tscn")
	var item = itemScene.instantiate()
	item.setResource(resourceName)
	item.position = building.player.tileMap.map_to_local(cellI)
	building.player.get_node("../Items").add_child(item)

func updatePlaceItemsMode():
	var config = building.inputConfigurationList.find("Place Items")
	var index = config.getIndex()
	if index == 0:
		placeItemsMode.mode = PlaceItemsMode.PLACE_ITEMS_MODE.DISABLED
	elif index == 1:
		placeItemsMode.mode = PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM
	else:
		placeItemsMode.mode = PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE
	
	config = building.inputConfigurationList.find("Chest Prio")
	placeItemsMode.chestPrio = config.getIndex() - 1
	
	config = building.inputConfigurationList.find("Conveyor Prio")
	placeItemsMode.conveyorPrio = config.getIndex() - 1
	
	config = building.inputConfigurationList.find("Other Prio")
	placeItemsMode.otherPrio = config.getIndex() - 1

func addUnit(unit: Node2D, pos: int):
	if unit is BuildUnit || unit is Item || unit is Building:
		spaceOccupied[pos] += 1

func removeUnit(unit: Node2D, pos: int):
	if unit is BuildUnit || unit is Item || unit is Building:
		spaceOccupied[pos] -= 1
