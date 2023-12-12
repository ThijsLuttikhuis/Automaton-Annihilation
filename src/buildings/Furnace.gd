class_name Furnace extends Building

const duration: float = 1.0

var spaceOccupied: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]

func _init():
	energyCost = 200
	resourceCost.add('Stone', 5)

func on_ready():
	pass
	
func on_physics_process(_dt):
	if actionQueue.actionsEmpty():
		$"Sprite2D".set_frame(0)
		if !inventory.is_empty():
			var resourceName = inventory.getFirstItem()
			var action = SmeltResourceAction.new(resourceName, duration)
			actionQueue.push_back(action)
			
func getDisplayName():
	return "Furnace"

func addUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] += 1
		print('furnace entered')
	
func removeUnit(unit, pos: int):
	if unit is BuildUnit || unit is Item:
		spaceOccupied[pos] -= 1
		print('furnace exited')

func pickupUnit(unit):
	if ghost:
		return
	if unit is Item:
		if Item.isSmeltable(unit):
			var problemAddingItem = inventory.addTillFull(unit.resourceName, 1)
			if problemAddingItem.resources.is_empty():
				var action = SmeltResourceAction.new(unit.resourceName, duration)
				actionQueue.push_back([action])
				unit.queue_free()
				
				print('furnace pickup')
