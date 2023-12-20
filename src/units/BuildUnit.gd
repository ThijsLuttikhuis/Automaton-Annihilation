class_name BuildUnit extends MoveUnit

var itemsInArea: Array[Item] = []

func pickupItemsInArea():
	for item in itemsInArea:
		inventory.add(item.resourceName, 1)
		item.queue_free()

func addUnit(unit):
	if unit is Item:
		itemsInArea.push_back(unit)

func removeUnit(unit):
	if unit is Item:
		itemsInArea.erase(unit)
