class_name Building extends Unit

const NameToTileMapIndex: Dictionary = {
	"Empty": Vector2(0,0),
	"Windmill": Vector2(1,0),
	"Mining Drill": Vector2(2,0),
	"Conveyor Belt": Vector2(3,0)
}

var nonBuilableResourceTiles: Array[String] = []

func canBuildOnTile(cellI: Vector2i):
	var tileMap = player.tileMap
	
	var buildingTile = tileMap.get_cell_tile_data(2, cellI)
	if buildingTile:
		return false
	
	var resourceTile = tileMap.get_cell_tile_data(1, cellI)
	var tileName = "Empty"
	if resourceTile:
		tileName = resourceTile.get_custom_data("resourceName")
	
	return !nonBuilableResourceTiles.has(tileName)

func toTileMapAtlasCoords():
	return NameToTileMapIndex[getDisplayName()]

static func NameToTileMapAtlasCoords(buildingName):
	return NameToTileMapIndex[buildingName]
