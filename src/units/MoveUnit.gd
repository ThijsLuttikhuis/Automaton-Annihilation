class_name MoveUnit extends Unit

const DISTANCE_THRESHOLD: float = 5.0
const TIME_TILL_UNSTUCK: float = 1.0

@onready var targetPosition: Vector2 = position

var stuckPosition: Vector2 = Vector2(9e9, 9e9)
var timeStuck = 0.0

@export var moveSpeed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_physics_process(dt):
	if isNavigationFinished():
		targetPosition = Vector2(9e9, 9e9)
	else:
		self.velocity = (targetPosition - position).normalized() * moveSpeed
	
	on2_physics_process(dt)

	move_and_slide_with_conveyors()
	
func on2_physics_process(_dt):
	pass

func move_and_slide_with_conveyors(dt: float = 0.01):
	var characterBody = self
	if isStuck(dt):
		characterBody.position += characterBody.velocity * dt
		return
		
	var conveyorSpeed = characterBody.conveyorPushSpeed
	if !conveyorSpeed.is_empty():
		characterBody.velocity += conveyorSpeed[0].getSpeed()
		characterBody.move_and_slide()
		characterBody.velocity -= conveyorSpeed[0].getSpeed()
	else:
		characterBody.move_and_slide()

func isNavigationFinished():
	return targetPosition == Vector2(9e9, 9e9) || \
		(position - targetPosition).length_squared() < DISTANCE_THRESHOLD * DISTANCE_THRESHOLD

func isStuck(dt: float):
	if isNavigationFinished():
		return false
	
	if (position - stuckPosition).length_squared() > DISTANCE_THRESHOLD * DISTANCE_THRESHOLD:
		stuckPosition = position
		timeStuck = 0
		
	var characterBody = self
	var count = characterBody.get_slide_collision_count()
	if count < 2:
		stuckPosition = position
		timeStuck = 0
	
	timeStuck += dt
	return timeStuck > TIME_TILL_UNSTUCK
