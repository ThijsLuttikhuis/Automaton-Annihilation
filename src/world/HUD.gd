class_name HUD extends CanvasLayer

var world: World
var player: Player

func _ready():
	world = $".."
	player = $"../Player"

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
	
	if unit:
		lbdisplay.show()
	else:
		lbdisplay.hide()
		
		

	var stateIndex = buildStateToTabIndex(state)
	tabContainer.set_current_tab(stateIndex)

	
	print('updating unit panel')
	pass

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
	
	
	
