class_name PickupItemsComponent extends Node2D

enum ACCEPT_ITEMS_MODE {NEVER = 0, ONLY_WHEN_EMPTY = 1, ONLY_WHEN_NOT_FULL = 2, ALWAYS = 3, ALWAYS_BUT_DO_NOT_PICKUP = 4}

const CHECK_PICKUP_TIME := 0.5

@onready var unit: Unit = $".."

var acceptItemsMode := ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL

var acceptedItemsList: Array[String] = []

var onPickupItemFunc: Callable = onPickupItem

var spaceOccupied: Array[Item] = []

func _ready():
	var inputBuild = unit.inputConfigurationList.inputBuild
	inputBuild.push_back(InputConfiguration.new("Pickup Items"))

func _physics_process(dt):
	if fmod(unit.timeAlive, CHECK_PICKUP_TIME) < dt:
		for item in spaceOccupied:
			if acceptsItem(item.resourceName):
				pickupResource(item)

func setRadius(radius):
	$"PickupArea/CollisionShape2D".shape.radius = radius

func pickupResource(item: Node2D):
	if unit.isGhost() || acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS_BUT_DO_NOT_PICKUP:
		return
	if item is Item:
		var problemAddingItem = unit.inventory.addTillFull(item.resourceName, 1)
		if problemAddingItem.resources.is_empty():
			item.queue_free()
			onPickupItemFunc.call(item)

func addUnit(item: Node2D):
	if item is Item:
		if acceptsItem(item.resourceName):
			pickupResource(item)
		else:
			spaceOccupied.push_back(item)

func removeUnit(item: Node2D):
	if item is Item:
		spaceOccupied.erase(item)

func acceptsItem(resourceName: String):
	updateAcceptItemsMode()
	if acceptItemsMode == ACCEPT_ITEMS_MODE.NEVER:
		return false
	
	unit.updateAcceptedItems()
	if !acceptedItemsList.is_empty():
		var itemInList := false
		for itemName in acceptedItemsList:
			if itemName == resourceName:
				itemInList = true
				break
		if !itemInList:
			return false
	
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS_BUT_DO_NOT_PICKUP:
		return true
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS:
		return true
	
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_EMPTY:
		return unit.inventory.is_empty()
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL:
		return !unit.inventory.is_full()

func updateAcceptItemsMode():
	var config = unit.inputConfigurationList.find("Pickup Items")
	if !config:
		return
		
	var index = config.getIndex()
	acceptItemsMode = index
	
func onPickupItem(_item: Item):
	pass
