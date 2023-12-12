class_name Unit extends CollisionObject2D

var player: Node
var actionQueue: ActionQueue

var ghost = false
var hasRotation = false

var energyCost: float = 0
var resourceCost: Inventory = Inventory.new(999)

var selectedActionPriority: int = 0
var energyStorage: float = 0

var inventory: Inventory = Inventory.new(1)

var buildPower: float
var buildRange: float
var buildActionList: BuildActionList

var conveyorPushSpeed: Array[ConveyorBelt] = []

@export var maxHealthPoints: float = 100.0
@export var healthPoints: float = maxHealthPoints

@export var moveSpeed: float = 0.0
@export var viewRange: float = 100.0
@export var radarRange: float = 100.0

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

func setGhost(ghost_: bool = true):
	ghost = ghost_
	var collisionShape = $"CollisionShape2D"
	collisionShape.disabled = ghost
	actionQueue.paused = ghost
	get_node("Sprite2D").material.set_shader_parameter("ghost_greyout", ghost)
	
func isGhost():
	return ghost
	
func getBuildActionList(buildmenuState):
	var list: Array[PackedScene] = []
	if buildmenuState == Utils.BUILD_MENU.ECONOMY:
		list = buildActionList.buildingsEconomy
	elif buildmenuState == Utils.BUILD_MENU.DEFENSE:
		list =  buildActionList.buildingsDefense
	elif buildmenuState == Utils.BUILD_MENU.UTILITY:
		list =  buildActionList.buildingsUtility
	elif buildmenuState == Utils.BUILD_MENU.FACTORY:
		list =  buildActionList.buildingsFactory
	
	return list

func getDisplayName():
	return "Unit name not set!"
