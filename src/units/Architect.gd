class_name Architect extends BuildUnit

func _init():
	buildRange = 100
	moveSpeed = 150
	selectedActionPriority = 3
	
	# TODO: remove
	inventory = Inventory.new(10)
	inventory.add('Iron Ore', 500)
	
func on_ready():
	buildActionList = BuildActionList.new()
	var windmill = preload("res://src/buildings/windmill.tscn")
	
	buildActionList.buildingsEconomy.push_back(windmill)
	
func on_physics_process(_dt):
	var characterBody = self
	characterBody.move_and_slide()
