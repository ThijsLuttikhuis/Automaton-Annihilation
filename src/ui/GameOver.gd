class_name GameOver extends Node2D

@onready var mainMenuScene = load("res://src/ui/MainMenu.tscn")

func onClickReturnToMainMenu():
	var _mainMenu = initMainmenuWindow()
	queue_free()

func initMainmenuWindow():
	if !is_queued_for_deletion():
		var mainMenu = mainMenuScene.instantiate()
		get_tree().root.add_child(mainMenu)
		return mainMenu
	else:
		# world should already be initialized
		return get_tree().root.get_node("MainMenu")
