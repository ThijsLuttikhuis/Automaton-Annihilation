class_name Chest extends Building

const timeToClose: float = 0.4

var timeLeftOpen: float = 0.0

func _init():
	energyCost = 100
	resourceCost.add('Iron Ore', 5)
	inventory = Inventory.new(20)
	
	selectedActionPriority = 3
	
func on_ready():
	pass

func on_physics_process(dt):
	if timeLeftOpen > 0.0:
		timeLeftOpen -= dt
		if timeLeftOpen <= 0.0:
			$"Sprite2D".set_frame(0)

func getDisplayName():
	return "Chest"

func pickupUnit(unit):
	if ghost:
		return
	if unit is Item:
		var problemAddingItem = inventory.addTillFull(unit.resourceName, 1)
		if problemAddingItem.resources.is_empty():
			unit.queue_free()
			openChest()
			
	print('chest entered')

func openChest():
	timeLeftOpen = timeToClose
	$"Sprite2D".set_frame(1)
