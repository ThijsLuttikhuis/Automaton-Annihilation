class_name Item extends CharacterBody2D

const SMELTABLE_ITEMS: Dictionary = {
	"Iron Ore": "Iron Plate",
	"Copper Ore": "Copper Plate"
}

var resourceName: String
var conveyorPushSpeed: Array[ConveyorBelt] = []
	
func _physics_process(_dt):
	move_and_slide_with_conveyors()

func move_and_slide_with_conveyors():
	var characterBody = self
	var conveyorSpeed = characterBody.conveyorPushSpeed
	if !conveyorSpeed.is_empty():
		characterBody.velocity += conveyorSpeed[0].getSpeed()
		characterBody.move_and_slide()
		characterBody.velocity -= conveyorSpeed[0].getSpeed()
	else:
		characterBody.move_and_slide()

func setResource(resourceName_):
	resourceName = resourceName_
	var texture = Utils.getResourceTexture(resourceName)
	$"Sprite2D".texture = texture
	
static func isSmeltable(itemName):
	if itemName is String:
		return SMELTABLE_ITEMS.has(itemName)
	if itemName is Item:
		return SMELTABLE_ITEMS.has(itemName.resourceName)
	assert(itemName is String || itemName is Item, 'itemName should be a String or Item')
	
static func getSmeltProduct(itemName):
	if itemName is String:
		return SMELTABLE_ITEMS[itemName]
	if itemName is Item:
		return SMELTABLE_ITEMS[itemName.resourceName]
	assert(itemName is String || itemName is Item, 'itemName should be a String or Item')


