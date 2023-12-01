class_name HUD extends CanvasLayer

var world: World
var player: Player
var lastUnit: Unit

func _ready():
	world = $".."
	player = $"../Player"
	
	var subViewport = $"LeftBottomDisplayBackground/TabContainer/Unit/SubViewportContainer/SubViewport"
#	subViewport.set_use_own_world(true)

func _process(_dt):
	var energy = world.getEnergy()
	var energyStorage = world.getEnergyStorage()
	var energyDisplay = $"TopDisplayBackground/EnergyDisplay"
	energyDisplay.text = "Energy: " + str(round(energy)) + " / " + str(round(energyStorage))
	
	var windSpeed = world.getWindSpeed()
	var windSpeedDisplay = $"TopDisplayBackground/WindSpeedDisplay"
	windSpeedDisplay.text = "Wind Speed: " + str(round(windSpeed * 10.0) / 10.0)

func updateBuildMenuPanel(state, building):
	var unit = player.getMainSelectedUnit()
	var lbdisplay = $"LeftBottomDisplayBackground"
	var tabContainer = $"LeftBottomDisplayBackground/TabContainer"
	
	if !unit:
		lastUnit = null
		lbdisplay.hide()
		return
		
	lbdisplay.show()
	
	var stateIndex = buildStateToTabIndex(state)
	tabContainer.set_current_tab(stateIndex)
	
	if unit == lastUnit:
		return
	
	var unitGrid = $"LeftBottomDisplayBackground/TabContainer/Unit"
	unitGrid.get_node("Label").text = unit.name
	
	if unit is BuildUnit:
		var ecoGrid = $"LeftBottomDisplayBackground/TabContainer/Economy"
		var defGrid = $"LeftBottomDisplayBackground/TabContainer/Defense"
		var utilGrid = $"LeftBottomDisplayBackground/TabContainer/Utility"
		var facGrid = $"LeftBottomDisplayBackground/TabContainer/Factory"
		var grids = [ecoGrid, defGrid, utilGrid, facGrid]
		
		var actionList = unit.buildActionList
		var buildLists = [actionList.buildingsEconomy, actionList.buildingsDefense, \
			actionList.buildingsUtility, actionList.buildingsFactory]
		
		for buildingType in range(4):
			var grid = grids[buildingType]
			var buildList = buildLists[buildingType]
		
			for i in range(buildList.size()):
				var ecoBuildingScene: PackedScene = buildList[i]
				var ecoBuilding: Building = ecoBuildingScene.instantiate()
				var texture = ecoBuilding.get_node("Sprite2D").texture
				var node = grid.get_node("TextureRect" + str(i))
				node.texture = texture
	
	
	print('updating unit panel')
	
	

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
	
#func buildStateToString(state):
#	if state == player.BUILD_MENU.ECONOMY:
#		return "Economy"
#	elif state == player.BUILD_MENU.DEFENSE:
#		return "Defense"
#	elif state == player.BUILD_MENU.UTILITY:
#		return "Utility"
#	elif state == player.BUILD_MENU.FACTORY:
#		return "Factory"
#	else:
#		return "Unit"
		
	
