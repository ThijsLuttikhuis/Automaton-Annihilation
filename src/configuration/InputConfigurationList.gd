class_name InputConfigurationList

var inputBuild: Array[InputConfiguration] = []
var inputCombat: Array[InputConfiguration] = []
var inputGeneral: Array[InputConfiguration] = []

func getAllInputConfigs():
	return [inputBuild, inputCombat, inputGeneral]

func getInputMapActionsPressed(isBuilding: bool):
	var actions: Array[String] = []
	for inputs in getAllInputConfigs():
		for config in inputs:
			if !isBuilding || (isBuilding && config.canPressWhileBuilding()):
				if Input.is_action_just_pressed(config.getInputMap()):
					actions.push_back(config.getInputMap())
				if !config.getInputMapPrev().is_empty() && Input.is_action_just_pressed(config.getInputMapPrev()):
					actions.push_back(config.getInputMapPrev())
	
	return actions

func find(name):
	if name is InputConfiguration:
		name = name.getName()
	assert(name is String, 'name should be a string or an InputConfiguration')
	
	for inputs in getAllInputConfigs():
		for config in inputs:
			if config.name == name:
				return config
	
	return null

func pressKey(action):
	assert(action is String && action.begins_with('ui'), 'action should be the name of an Input action')
	
	for inputs in getAllInputConfigs():
		for config in inputs:
			if config.getInputMap() == action:
				config.next()
				return true
			if config.getInputMapPrev() == action:
				config.prev()
	
	return false
