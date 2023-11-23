class_name Architect extends BuildUnit

func _init():
	moveSpeed = 150
	selectedActionPriority = 3
	
func on_ready():
	actionList = ActionList.new()
	var windmill = preload("res://src/buildings/windmill.tscn")
	
	actionList.buildingsEconomy.push_back(windmill)
	
func on_physics_process(_dt):
	var characterBody = self
	characterBody.move_and_slide()
