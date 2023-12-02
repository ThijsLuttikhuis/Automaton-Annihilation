class_name InventorySlot

#
#var resourceName: String
#var stackSize: int = 50
#var number: int
#
#func _init(name: String, n: int = 1):
#	assert(n > 0, 'InventorySlot:error: please init a positive number of resources')
#
#	stackSize = InventorySlot.name2StackSize(name)
#	assert(stackSize != 0, 'InventorySlot:error: invalid item name')
#	assert(n + number <= stackSize, 'InventorySlot:error: cannot set number beyond stacksize')
#	resourceName = name
#	number = n
#
#func isFull():
#	return number == stackSize
#
#func spaceTillFull():
#	return stackSize - number
#
#func add(n: int):
#	assert(n > 0, 'InventorySlot:error: please add a positive number of resources')
#	assert(n + number <= stackSize, 'InventorySlot:error: cannot add beyond stacksize')
#	number += n
#
#func addTillStackFull(n: int):
#	# returns the number of resources not added
#	assert(n > 0, 'InventorySlot:error: please add a positive number of resources')
#	var spaceLeft = stackSize - number
#	if n > spaceLeft:
#		number = stackSize
#		return n - spaceLeft
#	else:
#		number += n
#
#func removeTillStackEmpty(n: int):
#	# returns the number of resources not removed
#	assert(n > 0, 'InventorySlot:error: please remove a positive number of resources')
#	if n > number:
#		number = 0
#		return n - number
#	else:
#		number = number - n
#		return 0
#
#func removeIfEnoughResources(n: int):
#	# returns true if there are enough resources
#	assert(n > 0, 'InventorySlot:error: please remove a positive number of resources')
#	if n > number:
#		return false
#	else:
#		number -= n
#		return true
#
#func remove(n: int):
#	assert(number >= n, 'InventorySlot:error: not enough resources to remove this many items')
#	assert(n > 0, 'InventorySlot:error: please remove a positive number of resources')
#	number -= n
#
#func getResourceName():
#	return resourceName
#
#static func name2StackSize(name: String):
#	if name2StackSizeDict.has(name):
#		return name2StackSizeDict.get(name)
#	else:
#		return 0
#
