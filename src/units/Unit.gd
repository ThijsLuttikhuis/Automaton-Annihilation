class_name Unit extends PhysicsBody2D

var player: Node
var actionQueue: ActionQueue

var cost: Array[InventorySlot] = []

var selectedActionPriority: int = 0

var energyStorage: float

var inventory: Inventory

var buildPower: float
var buildRange: float
var buildActionList: BuildActionList

var moveSpeed: float = 0.0
var viewRange: float = 100.0
var radarRange: float = 100.0

func _ready():
	player = $"/root/World/Player"
	actionQueue = $"ActionQueue"
	
	on_ready()

func on_ready():
	pass # can be overwritten
	
func _physics_process(dt):
	if !actionQueue:
		return
		
	actionQueue.update(self, dt)
	on_physics_process(dt)
	
func on_physics_process(_dt):
	pass # can be overwritten	

func setGhost(ghost: bool = true):
	var collisionShape = $"CollisionShape2D"
	collisionShape.disabled = ghost
	actionQueue.paused = ghost
	get_node("Sprite2D").material.set_shader_parameter("ghost_greyout", ghost)



