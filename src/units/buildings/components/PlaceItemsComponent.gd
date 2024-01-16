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

@onready var building: Building = $".."

var spaceOccupiedBuildings := [0, 0, 0, 0, 0, 0, 0, 0]
var spaceOccupiedItems := [0, 0, 0, 0, 0, 0, 0, 0]
var spaceOccupiedMoveUnits := [0, 0, 0, 0, 0, 0, 0, 0]

func _ready():
	var inputBuild = building.inputConfigurationList.inputBuild
	inputBuild.push_back(InputConfiguration.new("Place Items"))
	inputBuild.push_back(InputConfiguration.new("Chest Prio"))
	inputBuild.push_back(InputConfiguration.new("Conveyor Prio"))
	inputBuild.push_back(InputConfiguration.new("Other Prio"))

func placeResource(resourceName: String) -> bool:
	updatePlaceItemsMode()
	
	var cellI = building.player.tileMap.local_to_map(global_position)
	
	var placeLocation = getCellIToPlaceResource(cellI, resourceName)
	if placeLocation != Vector2i(9e9, 9e9):
		placeDownItem(resourceName, placeLocation)
		return true
	
	return false

func getPlaceUnitPos() -> Vector2:
	updatePlaceItemsMode()
	
	var cellI = building.player.tileMap.local_to_map(global_position)
	var placeLocation = getCellIToPlaceUnit(cellI)
	if placeLocation == Vector2i(9e9, 9e9):
		return Vector2(9e9, 9e9)
	else:
		return building.player.tileMap.map_to_local(placeLocation)

func getCellIToPlaceUnit(cellI):
	var dirs = range(8)
	dirs.shuffle()
		
	for i in range(8):
		var dir = dirs[i]
		if spaceOccupiedItems[dir] || spaceOccupiedBuildings[dir] || spaceOccupiedMoveUnits[dir]:
			continue
		
		var dPos = indexToRelativeNeighbourPos(dir)
		var neighbourCellI = cellI + dPos
		var neighbourBuilding: Building = building.player.world.getBuildingFromCellI(neighbourCellI)
		
		if !neighbourBuilding:
			return neighbourCellI
	
	return Vector2i(9e9, 9e9)

func placeDownItem(resourceName: String, cellI: Vector2i):
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

func getCellIToPlaceResource(cellI, resourceName) -> Vector2i:
	var dirs = range(8)
	dirs.shuffle()
	
	for prioI in [2, 1, 0]:
		if !prioIInPlaceItemsMode(prioI):
			continue
		
		for i in range(8):
			var dir = dirs[i]
			if spaceOccupiedItems[dir] || spaceOccupiedMoveUnits[dir]:
				continue
			
			var dPos = indexToRelativeNeighbourPos(dir)
			var neighbourCellI = cellI + dPos
			var neighbourBuilding := building.player.world.getBuildingFromCellI(neighbourCellI)
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.DISABLED:
				return Vector2i(9e9, 9e9)
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE:
				if !neighbourBuilding || neighbourBuilding.acceptsItem(resourceName):
					return neighbourCellI
			
			if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM:
				if buildingAcceptsItem(neighbourBuilding, resourceName) && canPlaceInBuilding(neighbourBuilding, prioI, ):
					return neighbourCellI
	
	if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM:
		for i in range(8):
			var dir = dirs[i]
			if spaceOccupiedItems[dir] || spaceOccupiedBuildings[dir] || spaceOccupiedMoveUnits[dir]:
				continue
			
			var dPos = indexToRelativeNeighbourPos(dir)
			var neighbourCellI = cellI + dPos
			var neighbourBuilding: Building = building.player.world.getBuildingFromCellI(neighbourCellI)
			
			if !neighbourBuilding:
				return neighbourCellI
	
	return Vector2i(9e9, 9e9)

func canPlaceInBuilding(neighbourBuilding, prioI) -> bool:
	return (placeItemsMode.chestPrio == prioI && neighbourBuilding.getDisplayName() == "Chest") || \
	 	(placeItemsMode.conveyorPrio == prioI && neighbourBuilding.getDisplayName() == "Conveyor Belt") || \
	 	(placeItemsMode.otherPrio == prioI && neighbourBuilding.getDisplayName() != "Chest" && neighbourBuilding.getDisplayName() != "Conveyor Belt")

func buildingAcceptsItem(neighbourBuilding, resourceName) -> bool:
	return neighbourBuilding && \
		neighbourBuilding.has_node("PickupItemsComponent") && \
		neighbourBuilding.pickupItemsComponent.acceptsItem(resourceName)

func prioIInPlaceItemsMode(prioI) -> bool:
	if placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.CUSTOM && \
		!placeItemsMode.chestPrio == prioI && \
		!placeItemsMode.conveyorPrio == prioI && \
		!placeItemsMode.otherPrio == prioI:
		
		return false # skip inner for if there is no config with correct prio
	
	if prioI != 2 && \
		(placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.ANYWHERE ||\
		placeItemsMode.mode == PlaceItemsMode.PLACE_ITEMS_MODE.DISABLED):
		
		return false # prio is irrelevant if placeitemsmode is not custom
	
	return true

func indexToRelativeNeighbourPos(index: int) -> Vector2i: 
	var xDirs = [1, 1, 1, 0, -1, -1, -1, 0]
	var yDirs = [1, 0, -1, -1, -1, 0, 1, 1]
	return Vector2i(xDirs[index], yDirs[index])

func addUnit(unit: Node2D, pos: int):
	if unit is BuildUnit:
		spaceOccupiedMoveUnits[pos] += 1
	if unit is Item:
		spaceOccupiedItems[pos] += 1
	if unit is Building:
		spaceOccupiedBuildings[pos] += 1

func removeUnit(unit: Node2D, pos: int):
	if unit is BuildUnit:
		spaceOccupiedMoveUnits[pos] -= 1
	if unit is Item:
		spaceOccupiedItems[pos] -= 1
	if unit is Building:
		spaceOccupiedBuildings[pos] -= 1
