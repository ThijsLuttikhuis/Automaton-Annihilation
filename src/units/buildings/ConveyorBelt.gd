class_name ConveyorBelt extends Building

@onready var pickupItemsComponent: PickupItemsComponent = $"PickupItemsComponent"

var conveyorSpeed: float = 60

func _init():
	hasRotation = true
	energyCost = 50
	resourceCost.add('Iron Plate', 2)

func on_ready():
	updateDirection()
	
	call_deferred("after_ready")

func after_ready():
	pickupItemsComponent.acceptItemsMode = pickupItemsComponent.ACCEPT_ITEMS_MODE.ALWAYS_BUT_DO_NOT_PICKUP
	inputConfigurationList.erase("Pickup Items")

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

func updateAcceptedItems():
	return []
