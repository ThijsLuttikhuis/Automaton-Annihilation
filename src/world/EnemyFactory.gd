class_name EnemyFactory extends ConvertResourceBuilding

var time: float = 0.0
var timeBetweenSpawns: float = 5.0
var firstSpawnTime: float = 10.0

func _init():
	setMaxHealthPoints(9e9)
	
	var inputRecipe = Inventory.new()
	inputRecipe.add("Iron Gear", 1)
	var product = load("res://src/units/enemy_units/BasicEnemy.tscn")
	recipe = Recipe.new(inputRecipe, product)

func on2_physics_process(dt):
	if player.world.getDifficulty() == 0:
		return
	
	time += dt
	if time < firstSpawnTime:
		return
	
	if fmod(time, timeBetweenSpawns) < dt:
		inventory.add("Iron Gear", 1)

func removeHP(_value):
	pass # this building is not supposed to die :)

func getDisplayName():
	return "Enemy Factory"
