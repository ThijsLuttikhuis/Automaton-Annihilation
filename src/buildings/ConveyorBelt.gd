class_name ConveyorBelt extends Building

var conveyorSpeed: float = 60

func _init():
	hasRotation = true
	energyCost = 100
	resourceCost.add('Iron Plate', 3)

func on_ready():
	direction = -90 + ($"Sprite2D".frame * 90)

func updateDirection():
	direction = -90 + ($"Sprite2D".frame * 90)

func addUnit(unit):
	if unit is BuildUnit || unit is Item:
		unit.conveyorPushSpeed.push_back(self)

func removeUnit(unit):
	if unit is BuildUnit || unit is Item:
		unit.conveyorPushSpeed.erase(self)

func getSpeed():
	return Vector2(conveyorSpeed, 0).rotated(deg_to_rad(direction))

func getDisplayName():
	return "Conveyor Belt"
