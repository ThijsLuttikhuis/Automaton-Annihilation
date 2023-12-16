class_name MoveUnit extends Unit

const DISTANCE_THRESHOLD = 5

@onready var targetPosition: Vector2 = position

@export var moveSpeed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_physics_process(dt):
	
	if isNavigationFinished():
		targetPosition = Vector2(9e9, 9e9)
	else:
		self.velocity = (targetPosition - global_position).normalized() * moveSpeed
	
	on2_physics_process(dt)

	move_and_slide_with_conveyors()
	
func on2_physics_process(_dt):
	pass

func move_and_slide_with_conveyors():
	var characterBody = self
	var conveyorSpeed = characterBody.conveyorPushSpeed
	if !conveyorSpeed.is_empty():
		characterBody.velocity += conveyorSpeed[0].getSpeed()
		characterBody.move_and_slide()
		characterBody.velocity -= conveyorSpeed[0].getSpeed()
	else:
		characterBody.move_and_slide()

func isNavigationFinished():
	return targetPosition == Vector2(9e9, 9e9) ||\
		(position - targetPosition).length_squared() < DISTANCE_THRESHOLD * DISTANCE_THRESHOLD
