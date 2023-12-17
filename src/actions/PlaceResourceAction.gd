class_name PlaceResourceAction extends UnitAction

var resourceName: String

func placeResource(unit: Unit, checkForConveyorBeltsAndChests: bool, onlyBeltsFacingAway: bool = false):
	
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
		if (!checkForConveyorBeltsAndChests && !neighborTile) || \
			(neighborTile && neighborTile.get_custom_data("buildingName") == "Conveyor Belt") || \
			(neighborTile && neighborTile.get_custom_data("buildingName") == "Chest"):
			
			if onlyBeltsFacingAway && (neighborTile && neighborTile.get_custom_data("buildingName") == "Conveyor Belt"):
				var rotation = neighborTile.get_custom_data("rotation")
				if rotation == 0 && dxI == -1 || \
					rotation == -90 && dyI == 1 || \
					rotation == 90 && dyI == -1 || \
					rotation == 180 && dxI == 1:
					
					continue
			
			var itemScene = preload("res://src/items/Item.tscn")
			var item = itemScene.instantiate()
			item.setResource(resourceName)
			item.position = tileMap.map_to_local(neighborCellI)
			unit.player.get_node("../Items").add_child(item)
			return true
	
	return false
