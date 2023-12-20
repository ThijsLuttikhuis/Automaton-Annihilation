class_name Item extends CharacterBody2D

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
	$"Tooltip".tooltip_text = resourceName


