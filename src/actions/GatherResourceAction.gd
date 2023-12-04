class_name GatherResourceAction extends UnitAction



var efficiency: int = 1
var time: float = 0.0
var resourceGain: float = 0.0
var resourceName: String
var resourceRichness: float

func _init(efficiency_):
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	if actionPosition == Vector2(9e9, 9e9):
		actionPosition = unit.position
		var tileMap = unit.player.tileMap
		var cellI = tileMap.local_to_map(actionPosition)
		var tile = tileMap.get_cell_tile_data(1, cellI)
		resourceName = tile.get_custom_data("resourceName")
		resourceRichness = tile.get_custom_data("resourceRichness")
	
	time += dt
	resourceGain += resourceRichness * efficiency * dt
	if resourceGain > 1:
		resourceGain -= 1
		
		var placed = placeResource(unit, true) #check place on conveyor belts
		if !placed:
			placeResource(unit, false) #check place on ground
		else:
			pass #resource wasted
		
func placeResource(unit: Unit, checkForConveyorBelts: bool):
	
	var tileMap = unit.player.tileMap
	var cellI = tileMap.local_to_map(actionPosition)
	
	var xDirs = [1, 1, 1, 0, -1, -1, -1, 0]
	var yDirs = [1, 0, -1, -1, -1, 0, 1, 1]
	var dirs = range(8)
	dirs.shuffle()
	
	for i in range(8):
		if unit.spaceOccupied[dirs[i]]:
			continue
		
		var dxI = xDirs[dirs[i]]
		var dyI = yDirs[dirs[i]]
		var neighborCellI = cellI + Vector2i(dxI, dyI)
		var neighborTile = tileMap.get_cell_tile_data(2, neighborCellI)
		if (!checkForConveyorBelts && !neighborTile) || \
			(neighborTile && neighborTile.get_custom_data("buildingName") == "Conveyor Belt"):
			
			var itemScene = preload("res://src/items/Item.tscn") 
			var item = itemScene.instantiate()
			item.setResource(resourceName)
			item.position = tileMap.map_to_local(neighborCellI)
			unit.player.get_node("../Items").add_child(item)
			print("Gained 1 " + resourceName)
			return true
	
	return false
