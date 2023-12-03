class_name ConveyorBelt extends Building

var direction: float
var conveyorSpeed: float = 60

func _init():
	hasRotation = true
	energyCost = 100
	resourceCost.add('Iron Ore', 3)

func on_ready():
	var sprite = $"Sprite2D"
	direction = -90 + (sprite.frame * 90)


func updateDirection():
	var sprite = $"Sprite2D"
	direction = -90 + (sprite.frame * 90)

func addUnit(unit):
	if unit is BuildUnit || unit is Item:
		unit.conveyorPushSpeed.push_back(self)

	print('conveyor entered')
	
func removeUnit(unit):
	if unit is BuildUnit || unit is Item:
		unit.conveyorPushSpeed.erase(self)
	elif unit is Item:
		pass
	
	print('conveyor exited')

func getSpeed():
	return Vector2(conveyorSpeed, 0).rotated(deg_to_rad(direction))
	
func getDisplayName():
	return "Conveyor Belt"
