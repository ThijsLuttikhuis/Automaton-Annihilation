class_name Unit extends PhysicsBody2D

var player: Node
var actionQueue: ActionQueue

var selectedActionPriority: int = 0

var moveSpeed: float = 0.0
var viewRange: float = 100.0
var radarRange: float = 100.0

func _ready():
	player = get_node('/root/World/Player')
	actionQueue = get_node('ActionQueue')
	
	on_ready()

func on_ready():
	pass # can be overwritten
	
func _physics_process(dt):
	actionQueue.update(self, dt)
	on_physics_process(dt)
	
func on_physics_process(_dt):
	pass # can be overwritten	
