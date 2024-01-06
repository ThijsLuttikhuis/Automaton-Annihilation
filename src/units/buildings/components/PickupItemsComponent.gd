class_name PickupItemsComponent extends Area2D

enum ACCEPT_ITEMS_MODE {NEVER = 0, ONLY_WHEN_EMPTY = 1, ONLY_WHEN_NOT_FULL = 2, ALWAYS = 3}

const CHECK_PICKUP_TIME := 0.5

var acceptItemsMode := ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL

var onPickupItemFunc: Callable = onPickupItem

var unit: Unit


var spaceOccupied: Array[Item] = []

func _ready():
	unit = $".."
	
	var inputBuild = unit.inputConfigurationList.inputBuild
	inputBuild.push_back(InputConfiguration.new("Pickup Items"))

func _physics_process(dt):
	if fmod(unit.timeAlive, CHECK_PICKUP_TIME) < dt:
		for item in spaceOccupied:
			if acceptsItem(item.resourceName):
				pickupResource(item)

func setRadius(radius):
	$"CollisionShape2D".shape.radius = radius

func pickupResource(item: Node2D):
	if unit.isGhost():
		return
	if item is Item:
		var problemAddingItem = unit.inventory.addTillFull(item.resourceName, 1)
		if problemAddingItem.resources.is_empty():
			item.queue_free()
			onPickupItemFunc.call()

func addUnit(item: Node2D):
	if item is Item:
		if acceptsItem(item.resourceName):
			pickupResource(item)
		else:
			spaceOccupied.push_back(item)

func removeUnit(item: Node2D):
	if item is Item:
		spaceOccupied.erase(item)

func acceptsItem(_resourceName: String):
	updateAcceptItemsMode()
	
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ALWAYS:
		return true
	if acceptItemsMode == ACCEPT_ITEMS_MODE.NEVER:
		return false
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_EMPTY:
		return unit.inventory.is_empty()
	if acceptItemsMode == ACCEPT_ITEMS_MODE.ONLY_WHEN_NOT_FULL:
		return !unit.inventory.is_full()

func updateAcceptItemsMode():
	var config = unit.inputConfigurationList.find("Pickup Items")
	var index = config.getIndex()
	acceptItemsMode = index
	
func onPickupItem():
	pass
