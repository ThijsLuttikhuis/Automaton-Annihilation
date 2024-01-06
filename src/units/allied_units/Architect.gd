class_name Architect extends BuildUnit

@onready var pickupItemsComponent: PickupItemsComponent = $"PickupItemsComponent"

func _init():
	buildRange = 50
	moveSpeed = 150
	selectedActionPriority = 9
	healthRegen = 0.5
	
	inventory.setNumberOfSlots(5)

func on_ready():
	initBuildActionList()
	initInputConfiguration()
	
	pickupItemsComponent.setRadius(14.0)

func initBuildActionList():
	buildActionList.tabNames = ["Economy", "Defense", "Utility", "Factory"]
	
	var miningdrill = preload("res://src/units/buildings/MiningDrill.tscn")
	buildActionList.units0.push_back(miningdrill)
	var solarpanel = preload("res://src/units/buildings/SolarPanel.tscn")
	buildActionList.units0.push_back(solarpanel)
	var windmill = preload("res://src/units/buildings/Windmill.tscn")
	buildActionList.units0.push_back(windmill)
	
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	buildActionList.units0.push_back(miningdrill)
	
	var chest = preload("res://src/units/buildings/Chest.tscn")
	buildActionList.units0.push_back(chest)
	
	var energystorage = preload("res://src/units/buildings/EnergyStorage.tscn")
	buildActionList.units0.push_back(energystorage)
	
	var energytower = preload("res://src/units/buildings/EnergyTower.tscn")
	buildActionList.units1.push_back(energytower)
	
	#var lasertower = preload("res://src/buildings/LaserTower.tscn")
	#buildActionList.units1.push_back(lasertower)
	
	var conveyorbelt = preload("res://src/units/buildings/ConveyorBelt.tscn")
	buildActionList.units3.push_back(conveyorbelt)
	
	var furnace = preload("res://src/units/buildings/Furnace.tscn")
	buildActionList.units3.push_back(furnace)
	
	buildActionList.units3.push_back(furnace)
	buildActionList.units3.push_back(furnace)
	
	var assembler = preload("res://src/units/buildings/Assembler.tscn")
	buildActionList.units3.push_back(assembler)

	var mechlab = preload("res://src/units/buildings/MechLab.tscn")
	buildActionList.units3.push_back(mechlab)

func initInputConfiguration():
	var rotationconf = InputConfiguration.new("Rotation")
	inputConfigurationList.inputBuild.push_back(rotationconf)
	
	var chestpickup = InputConfiguration.new("Chest Pickup")
	inputConfigurationList.inputBuild.push_back(chestpickup)
	
	var demolishC = InputConfiguration.new("Demolish")
	inputConfigurationList.inputBuild.push_back(demolishC)

func onDestroyed():
	player.world.initGameOverWindow()
	player.world.queue_free()

func onDemolished():
	onDestroyed()

func getDisplayName():
	return "Architect"
