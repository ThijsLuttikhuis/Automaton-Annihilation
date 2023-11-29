class_name Inventory

var nSlots: int
var inventorySlots: Array[InventorySlot]

func _init(nSlots_: int = 5):
	nSlots = nSlots_

func remove(inventorySlotsToRemove: Array[InventorySlot]):
	var missingSlots = removeTillEmpty(inventorySlotsToRemove)
	assert(missingSlots.is_empty(), 'Inventory:error: inventory empty, try to use removeTillEmpty instead')

func removeTillEmpty(inventorySlotsToRemove: Array[InventorySlot]):
	var missingSlots: Array[InventorySlot] = []
	for inventorySlotToRemove in inventorySlotsToRemove:
		var name: String = inventorySlotToRemove.getResourceName()
		var n: int = inventorySlotToRemove.number
		for inventorySlot in inventorySlots:
			if inventorySlot.getResourceName() == name:
				n = inventorySlot.removeTillStackEmpty(n)
				if n == 0:
					break
		
		if n > 0:
			var newSlot = InventorySlot.new(name, n)
			missingSlots.push_back(newSlot)
	
	return missingSlots

func add(inventorySlotsToAdd: Array[InventorySlot]):
	var overflow = addTillFull(inventorySlotsToAdd)
	assert(overflow.is_empty(), 'Inventory:error: inventory full, try to use addTillFull instead')

func addTillFull(inventorySlotsToAdd: Array[InventorySlot]):
	var overflow: Array[InventorySlot] = []
	for inventorySlotToAdd in inventorySlotsToAdd:
		var name: String = inventorySlotToAdd.getResourceName()
		var n: int = inventorySlotToAdd.number
		for inventorySlot in inventorySlots:
			if inventorySlot.getResourceName() == name:
				n = inventorySlot.addTillStackFull(n)
				if n == 0:
					break
		
		assert(inventorySlots.size() <= nSlots, 'Inventory:error: more slots used than available')
		while n > 0:
			if inventorySlots.size() == nSlots:
				overflow.push_back(InventorySlot.new(name, n))
			
			var stackSize = InventorySlot.name2StackSize(name)
			var toAdd = min(n, stackSize)
			var newSlot = InventorySlot.new(name, toAdd)
			inventorySlots.push_back(newSlot)
			n -= toAdd
	
	return overflow

func hasResources(inventorySlotsToCheck: Array[InventorySlot]):
	var inventorySlotsCopy = deepCopy(inventorySlots)
	var inventorySlotsToCheckCopy = deepCopy(inventorySlotsToCheck)
	
	var temp = inventorySlots
	inventorySlots = inventorySlotsCopy
	var missingSlots = removeTillEmpty(inventorySlotsToCheckCopy)
	inventorySlots = temp
	
	return missingSlots.is_empty()

func ifHasResourcesRemove(inventorySlotsToRemove: Array[InventorySlot]):
	if hasResources(inventorySlotsToRemove):
		remove(inventorySlotsToRemove)
		return true
	else:
		return false
	
func deepCopy(slots: Array[InventorySlot]):
	var copySlots: Array[InventorySlot] = []
	for slot in slots:
		var copySlot = InventorySlot.new(slot.getResourceName(), slot.number)
		copySlots.push_back(copySlot)
	return copySlots
