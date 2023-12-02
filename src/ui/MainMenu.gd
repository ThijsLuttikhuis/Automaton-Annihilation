class_name MainMenu extends Node2D

func _ready():
	var playButton = $"PlayButton"
	var settingsButton = $"SettingsButton"
	playButton.button_down.connect(onClickPlay)
	settingsButton.button_down.connect(onClickSettings)
	
func onClickPlay():
	get_tree().change_scene_to_file("res://src/world/World.tscn")

func onClickSettings():
	print("settings")
