class_name Architect extends BuildUnit

func _init():
	buildRange = 50
	moveSpeed = 150
	selectedActionPriority = 9
	
	inventory.setNumberOfSlots(5)

func _ready():
	initBuildActionList()
	initInputConfiguration()

func initBuildActionList():
	var miningdrill = preload("res://src/buildings/MiningDrill.tscn")
	buildActionList.buildingsEconomy.push_back(miningdrill)
	var solarpanel = preload("res://src/buildings/SolarPanel.tscn")
	buildActionList.buildingsEconomy.push_back(solarpanel)
	var windmill = preload("res://src/buildings/Windmill.tscn")
	buildActionList.buildingsEconomy.push_back(windmill)
	
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	buildActionList.buildingsEconomy.push_back(miningdrill)
	
	var chest = preload("res://src/buildings/Chest.tscn")
	buildActionList.buildingsEconomy.push_back(chest)
	
	var energystorage = preload("res://src/buildings/EnergyStorage.tscn")
	buildActionList.buildingsEconomy.push_back(energystorage)
	
	var conveyorbelt = preload("res://src/buildings/ConveyorBelt.tscn")
	buildActionList.buildingsFactory.push_back(conveyorbelt)
	
	var furnace = preload("res://src/buildings/Furnace.tscn")
	buildActionList.buildingsFactory.push_back(furnace)
	
	buildActionList.buildingsFactory.push_back(furnace)
	buildActionList.buildingsFactory.push_back(furnace)
	
	var assembler = preload("res://src/buildings/Assembler.tscn")
	buildActionList.buildingsFactory.push_back(assembler)

	var mechlab = preload("res://src/buildings/MechLab.tscn")
	buildActionList.buildingsFactory.push_back(mechlab)

func initInputConfiguration():
	var pickupitems = InputConfiguration.new("Pickup Items")
	inputConfigurationList.inputBuild.push_back(pickupitems)
	
	var rotationconf = InputConfiguration.new("Rotation")
	inputConfigurationList.inputBuild.push_back(rotationconf)
	
	var chestpickup = InputConfiguration.new("Chest Pickup")
	inputConfigurationList.inputBuild.push_back(chestpickup)

func getDisplayName():
	return "Architect"
