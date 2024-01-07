class_name Chest extends Building

@onready var pickupItemsComponent: PickupItemsComponent = $"PickupItemsComponent"

const timeToClose: float = 0.4
var timeLeftOpen: float = 0.0

func _init():
	energyCost = 100
	resourceCost.add('Iron Plate', 4)
	inventory = Inventory.new(20)
	
	selectedActionPriority = 3

func on_ready():
	pickupItemsComponent.onPickupItemFunc = openChest

func on_physics_process(dt):
	if timeLeftOpen > 0.0:
		timeLeftOpen -= dt
		if timeLeftOpen <= 0.0:
			$"Sprite2D".set_frame(0)

func openChest(_item: Item = null):
	timeLeftOpen = timeToClose
	$"Sprite2D".set_frame(1)

func getDisplayName():
	return "Chest"

func updateAcceptedItems() -> Array[String]:
	if isGhost():
		return ["Empty"]
	return []
