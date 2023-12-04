class_name BuildUnit extends Unit

var itemsInArea: Array[Item] = []
func move_and_slide_with_conveyors():
	var characterBody = self
	var conveyorSpeed = characterBody.conveyorPushSpeed
	if !conveyorSpeed.is_empty():
		characterBody.velocity += conveyorSpeed[0].getSpeed()
		characterBody.move_and_slide()
		characterBody.velocity -= conveyorSpeed[0].getSpeed()
	else:
		characterBody.move_and_slide()

func pickupItemsInArea():
	for item in itemsInArea:
		inventory.add(item.resourceName, 1)
		item.queue_free()

func addUnit(unit):
	if unit is Item:
		itemsInArea.push_back(unit)
	
	print('architect entered')

func removeUnit(unit):
	if unit is Item:
		itemsInArea.erase(unit)
	
	print('architect exited')
