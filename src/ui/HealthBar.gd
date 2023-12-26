class_name HealthBar extends Control

@onready var progressBar: TextureProgressBar = $"ProgressBar"
var unit: Unit


func _ready():
	unit = $"../.."

func update():
	progressBar.max_value = unit.maxHealthPoints
	progressBar.value = unit.healthPoints
	
	if unit.healthPoints / unit.maxHealthPoints > 0.99:
		print( unit.healthPoints / unit.maxHealthPoints)
		hide()
	else:
		show()
