extends Node

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

var buildmenuState: BUILD_MENU = BUILD_MENU.NONE
var selectedElements: Unit


func _process(_dt):
	
	if Input.is_action_just_pressed("ui_buildmenu_economy"):
		buildmenuState = BUILD_MENU.ECONOMY
	
	if Input.is_action_just_pressed("ui_buildmenu_defense"):
		buildmenuState = BUILD_MENU.DEFENSE
	
	if Input.is_action_just_pressed("ui_buildmenu_utility"):
		buildmenuState = BUILD_MENU.UTILITY
	
	if Input.is_action_just_pressed("ui_buildmenu_factory"):
		buildmenuState = BUILD_MENU.FACTORY
	
	
