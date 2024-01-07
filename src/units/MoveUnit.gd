class_name MoveUnit extends Unit

const DISTANCE_THRESHOLD: float = 5.0

const UNSTUCK_DISTANCE_THRESHOLD: float = 5.0
const HARD_UNSTUCK_DISTANCE_THRESHOLD: float = 10.0
const TIME_TILL_UNSTUCK: float = 0.5
const TIME_TILL_HARD_UNSTUCK: float = 1.5

var stuckPosition: Vector2 = Vector2(9e9, 9e9)
var hardStuckPosition: Vector2 = Vector2(9e9, 9e9)
var timeStuck = 0.0
var timeHardStuck = 0.0

@onready var targetPosition: Vector2 = position

@export var moveSpeed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(dt):
	super._physics_process(dt)
	
	if isNavigationFinished():
		targetPosition = Vector2(9e9, 9e9)
	else:
		self.velocity = (targetPosition - position).normalized() * moveSpeed
	
	on_physics_process(dt)
	move_and_slide_with_conveyors()

func move_and_slide_with_conveyors(dt: float = 0.01):
	var characterBody = self
	if isStuck(dt):
		characterBody.position += characterBody.velocity * dt
		
		var building := player.world.getBuildingFromPosition(targetPosition)
		if building:
			if actionQueue.get_front() && actionQueue.get_front() is MoveAction:
				actionQueue.pop_front()
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
	
	var characterBody = self
	var count = characterBody.get_slide_collision_count()
	if count == 0:
		stuckPosition = position
		timeStuck = 0
		
	if (position - stuckPosition).length_squared() > UNSTUCK_DISTANCE_THRESHOLD * UNSTUCK_DISTANCE_THRESHOLD:
		stuckPosition = position
		timeStuck = 0
	
	if (position - hardStuckPosition).length_squared() > HARD_UNSTUCK_DISTANCE_THRESHOLD * HARD_UNSTUCK_DISTANCE_THRESHOLD:
		hardStuckPosition = position
		timeHardStuck = 0
	
	timeStuck += dt
	timeHardStuck += dt
	
	return timeStuck > TIME_TILL_UNSTUCK || timeHardStuck > TIME_TILL_HARD_UNSTUCK
