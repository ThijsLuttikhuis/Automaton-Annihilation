class_name Architect extends BuildUnit

func _init():
	buildRange = 50
	moveSpeed = 150
	selectedActionPriority = 9
	healthRegen = 0.5
	
	inventory.setNumberOfSlots(5)

func on_ready():
	initBuildActionList()
	initInputConfiguration()

func initBuildActionList():
	buildActionList.tabNames = ["Economy", "Defense", "Utility", "Factory"]
	
	var miningdrill = preload("res://src/buildings/MiningDrill.tscn")
	buildActionList.units0.push_back(miningdrill)
	var solarpanel = preload("res://src/buildings/SolarPanel.tscn")
	buildActionList.units0.push_back(solarpanel)
	var windmill = preload("res://src/buildings/Windmill.tscn")
	buildActionList.units0.push_back(windmill)
	
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	
	var chest = preload("res://src/buildings/Chest.tscn")
	buildActionList.units0.push_back(chest)
	
	var energystorage = preload("res://src/buildings/EnergyStorage.tscn")
	buildActionList.units0.push_back(energystorage)
	
	var energytower = preload("res://src/buildings/EnergyTower.tscn")
	buildActionList.units1.push_back(energytower)
	
	#var lasertower = preload("res://src/buildings/LaserTower.tscn")
	#buildActionList.units1.push_back(lasertower)
	
	var conveyorbelt = preload("res://src/buildings/ConveyorBelt.tscn")
	buildActionList.units3.push_back(conveyorbelt)
	
	var furnace = preload("res://src/buildings/Furnace.tscn")
	buildActionList.units3.push_back(furnace)
	
	buildActionList.units3.push_back(furnace)
	buildActionList.units3.push_back(furnace)
	
	var assembler = preload("res://src/buildings/Assembler.tscn")
	buildActionList.units3.push_back(assembler)

	var mechlab = preload("res://src/buildings/MechLab.tscn")
	buildActionList.units3.push_back(mechlab)

func initInputConfiguration():
	var pickupitems = InputConfiguration.new("Pickup Items")
	inputConfigurationList.inputBuild.push_back(pickupitems)
	
	var rotationconf = InputConfiguration.new("Rotation")
	inputConfigurationList.inputBuild.push_back(rotationconf)
	
	var chestpickup = InputConfiguration.new("Chest Pickup")
	inputConfigurationList.inputBuild.push_back(chestpickup)
	
	var demolishC = InputConfiguration.new("Demolish")
	inputConfigurationList.inputBuild.push_back(demolishC)

func getDisplayName():
	return "Architect"

func onDestroyed():
	player.world.initGameOverWindow()
	player.world.queue_free()

func onDemolished():
	onDestroyed()
