class_name Unit extends CollisionObject2D

@onready var player: Player = $"/root/World/Player"
@onready var actionQueue: ActionQueue = $"ActionQueue"

var buildActionList: BuildActionList = BuildActionList.new()
var inputConfigurationList: InputConfigurationList = InputConfigurationList.new()

var healthBar: HealthBar
var maxHealthPoints: float = 100.0
var healthPoints: float = maxHealthPoints
var healthRegen: float = 0.0
var timeAlive: float = 0.0

var ghost = false
var hasRotation = false

var energyCost: float = 0
var resourceCost: Inventory = Inventory.new(999)

var selectedActionPriority: int = 0
var energyStorage: float = 0

var inventory: Inventory = Inventory.new(1)

var buildPower: float
var buildRange: float

var conveyorPushSpeed: Array[ConveyorBelt] = []


var viewRange: float = 100.0
var radarRange: float = 100.0

func _ready():
	healthBar = $"Sprite2D/HealthBar"
	if healthBar:
		healthBar.update()
	else:
		print(name + " is missing a health bar")
	on_ready()

func on_ready():
	pass # can be overwritten
	
func _physics_process(dt):
	timeAlive += dt
	
	if fmod(timeAlive, 1) < dt:
		addHP(healthRegen)
	
	if actionQueue:
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
	
func getBuildActionList(buildmenuTab):
	var list: Array = []
	if buildmenuTab == 1:
		list = buildActionList.units0
	elif buildmenuTab == 2:
		list = buildActionList.units1
	elif buildmenuTab == 3:
		list = buildActionList.units2
	elif buildmenuTab == 4:
		list = buildActionList.units3
	
	return list

func setMaxHealthPoints(value: float, setHealthToMax: bool = true):
	assert(value >= 0.0, 'cannot set a negative max health')
	maxHealthPoints = value
	if setHealthToMax:
		healthPoints = maxHealthPoints

func removeHP(points: float):
	assert(points >= 0.0, 'cannot remove a negative amount of health')
	
	healthPoints -= points
	if healthBar:
		healthBar.update()
	
	if healthPoints <= 0.0:
		onDestroyed()
		queue_free()
		return

func addHP(points: float):
	assert(points >= 0.0, 'cannot add a negative amount of health')
	
	healthPoints += points
	healthPoints = min(healthPoints, maxHealthPoints)
	
	if healthBar:
		healthBar.update()

func demolish():
	
	onDemolished()
	queue_free()

func onDestroyed():
	pass

func onDemolished():
	pass

func getDisplayName() -> String:
	return "Unit name not set!"

func getShootPosition() -> Vector2:
	return position
