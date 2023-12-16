class_name Architect extends BuildUnit

func _init():
	buildRange = 30
	moveSpeed = 150
	selectedActionPriority = 9
	
	inventory = Inventory.new(999)
	inventory.add('Iron Plate', 50)
	inventory.add('Stone', 15)
	
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
	
func initInputConfiguration():
	var inputPickupItems = InputConfiguration.new("Pickup Items")
	inputConfigurationList.inputBuild.push_back(inputPickupItems)
	
	var inputRotation = InputConfiguration.new("Rotation")
	inputConfigurationList.inputBuild.push_back(inputRotation)
	pass

func getDisplayName():
	return "Architect"

