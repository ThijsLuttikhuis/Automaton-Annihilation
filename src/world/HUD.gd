class_name HUD extends CanvasLayer

var world: World

func _ready():
	world = $".."

func _process(_dt):
	var energy = world.getEnergy()
	var energyStorage = world.getEnergyStorage()
	var energyDisplay = $"TopDisplayBackground/EnergyDisplay"
	energyDisplay.text = "Energy: " + str(round(energy)) + " / " + str(round(energyStorage))
	
	var windSpeed = world.getWindSpeed()
	var windSpeedDisplay = $"TopDisplayBackground/WindSpeedDisplay"
	windSpeedDisplay.text = "Wind Speed: " + str(round(windSpeed * 10.0) / 10.0)
