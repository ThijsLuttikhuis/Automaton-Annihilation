class_name Building extends Unit

enum ACCEPT_ITEMS_MODE {
	NEVER, 
	ONLY_WHEN_EMPTY, 
	ONLY_WHEN_NOT_FULL, 
	ALWAYS
}

const NAME_TO_TILEMAP_INDEX: Dictionary = {
	"Empty": Vector2(0,0),
	"Windmill": Vector2(1,0),
	"Mining Drill": Vector2(2,0),
	"Conveyor Belt": Vector2(3,0),
	"Solar Panel": Vector2(4,0),
	"Chest": Vector2(5,0),
	"Energy Storage": Vector2(6,0),
	"Furnace": Vector2(7,0),
	"Mech Lab": Vector2(8,0),
	"Assembler": Vector2(9,0),
	"Energy Tower": Vector2(10,0),
	"Laser Tower": Vector2(11,0)
}

var direction: float

var nonBuilableResourceTiles: Array[String] = []

var acceptItemsMode: ACCEPT_ITEMS_MODE = ACCEPT_ITEMS_MODE.NEVER

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
	var coords = NAME_TO_TILEMAP_INDEX[getDisplayName()]
	coords.y = $"Sprite2D".frame
	return coords

static func NameToTileMapAtlasCoords(buildingName):
	return NAME_TO_TILEMAP_INDEX[buildingName]

func acceptsItem(_resourceName: String):
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS:
		return true
	if acceptItemsMode == ACCEPT_ITEMS_MODE.NEVER:
		return false
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_EMPTY:
		return inventory.is_empty()
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL:
		return !inventory.is_full()
