class_name HUD extends CanvasLayer

var world: World


func _ready():
	world = $".."

func _process(delta):
	var energy = world.getEnergy()
	var energyDisplay = $"EnergyDisplay"
	energyDisplay.text = "Energy: " + str(round(energy))
	
	
	
