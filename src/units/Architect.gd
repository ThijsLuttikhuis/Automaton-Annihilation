class_name Architect extends BuildUnit

func _init():
	buildRange = 100
	moveSpeed = 150
	selectedActionPriority = 3
	
	# TODO: remove
	inventory = Inventory.new(999)
	inventory.add('Iron Ore', 50)
	
func on_ready():
	buildActionList = BuildActionList.new()

	var miningdrill = preload("res://src/buildings/MiningDrill.tscn")
	buildActionList.buildingsEconomy.push_back(miningdrill)
	var solarpanel = preload("res://src/buildings/SolarPanel.tscn")
	buildActionList.buildingsEconomy.push_back(solarpanel)
	var windmill = preload("res://src/buildings/Windmill.tscn")
	buildActionList.buildingsEconomy.push_back(windmill)
	var chest = preload("res://src/buildings/Chest.tscn")
	buildActionList.buildingsEconomy.push_back(chest)
	
	
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	
	var conveyorbelt = preload("res://src/buildings/ConveyorBelt.tscn")
	buildActionList.buildingsFactory.push_back(conveyorbelt)
	
func on_physics_process(_dt):
	move_and_slide_with_conveyors()

func getDisplayName():
	return "Architect"
