class_name HUD extends CanvasLayer

var world: World
var player: Player
var selectUnitPanel: Container
var worldStatePanel: Container

var lastUnit: Unit

func _ready():
	world = $".."
	player = $"../Player"
	worldStatePanel = $"WorldStateColor/WorldStatePanel"
	selectUnitPanel = $"SelectUnitColor/SelectUnitPanel"
	
	for child in selectUnitPanel.get_children():
		if child.name == "Unit":
			continue
		
		var buildingUIScene = preload("res://src/ui/buildingUI.tscn")
		var order = [8,9,10,11,4,5,6,7,0,1,2,3]
		for i in order:
			var buildingUI = buildingUIScene.instantiate()
			buildingUI.name = "Building" + str(i)
			child.add_child(buildingUI)
	
func _process(_dt):
	var energy = world.getEnergy()
	var energyStorage = world.getEnergyStorage()
	var energyDisplay = worldStatePanel.get_node("EnergyDisplay")
	energyDisplay.text = "Energy: " + str(round(energy)) + " / " + str(round(energyStorage))
	
	var windSpeed = world.getWindSpeed()
	var windSpeedDisplay = worldStatePanel.get_node("WindSpeedDisplay")
	windSpeedDisplay.text = "Wind Speed: " + str(round(windSpeed * 10.0) / 10.0)

func updateBuildMenuPanel(state):
	var unit = player.getMainSelectedUnit()
	
	if !unit:
		lastUnit = null
		selectUnitPanel.get_parent().hide()
		return
		
	selectUnitPanel.get_parent().show()
	
	var stateIndex = buildStateToTabIndex(state)
	selectUnitPanel.set_current_tab(stateIndex)
	
	if unit == lastUnit:
		return
	
	var unitGrid = selectUnitPanel.get_node("Unit")
	unitGrid.get_node("Label").text = unit.name
	
	if unit is BuildUnit:
		var actionList = unit.buildActionList
		var buildStr = ["Economy", "Defense", "Utility", "Factory"] 
		var buildLists = [actionList.buildingsEconomy, actionList.buildingsDefense, \
			actionList.buildingsUtility, actionList.buildingsFactory]
		
		for i in range(4):
			var buildList = buildLists[i]
			var grid = selectUnitPanel.get_node(buildStr[i])
			
			for j in range(12):
				var gridElement = grid.get_node("Building" + str(j))
				if j >= buildList.size():
					gridElement.hide()
					continue
					
				gridElement.show()
				var buildingScene: PackedScene = buildList[j]
				var building: Building = buildingScene.instantiate()
				
				updateGridElementTexture(gridElement, building)
				updateGridElementCost(gridElement, building)
				
	
	print('updating unit panel')

func updateGridElementTexture(gridElement, building):
	var texture = building.get_node("Sprite2D").texture
	var nodeTexture = gridElement.get_node("Texture")
	nodeTexture.texture = texture

func updateGridElementCost(gridElement, building):
	gridElement.get_node("Cost/Energy/Value").text = str(building.energyCost)
	
	var resoureceCost = building.resourceCost
	

func buildStateToTabIndex(state):
	if state == player.BUILD_MENU.ECONOMY:
		return 1
	elif state == player.BUILD_MENU.DEFENSE:
		return 2
	elif state == player.BUILD_MENU.UTILITY:
		return 3
	elif state == player.BUILD_MENU.FACTORY:
		return 4
	else:
		return 0
	
func buildStateToString(state):
	if state == player.BUILD_MENU.ECONOMY:
		return "Economy"
	elif state == player.BUILD_MENU.DEFENSE:
		return "Defense"
	elif state == player.BUILD_MENU.UTILITY:
		return "Utility"
	elif state == player.BUILD_MENU.FACTORY:
		return "Factory"
	else:
		return "Unit"
