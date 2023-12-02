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
		var tileMap = unit.player.get_node("../WorldTileMap")
		var tileI = tileMap.local_to_map(actionPosition)
		var tile = tileMap.get_cell_tile_data(1, tileI)
		resourceName = tile.get_custom_data("resourceName")
		resourceRichness = tile.get_custom_data("resourceRichness")
	
	time += dt
	resourceGain += resourceRichness * efficiency * dt
	if resourceGain > 1:
		resourceGain -= 1
		print("Gained 1 " + resourceName)
