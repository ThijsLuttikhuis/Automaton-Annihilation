class_name InputConfigurationList

var inputBuild: Array[InputConfiguration] = []
var inputCombat: Array[InputConfiguration] = []
var inputGeneral: Array[InputConfiguration] = []

func update(selectedUnits: Array[Unit], isBuilding: bool):
	var actions = getInputMapActionsPressed(isBuilding)
	for action in actions:
		var value = pressKey(action)
		for unit in selectedUnits:
			unit.inputConfigurationList.pressKey(action, value)
	
	actions = getInputMapActionsReleased(isBuilding)
	for action in actions:
		for unit in selectedUnits:
			unit.inputConfigurationList.pressKey(action, 0)
	
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
				if !config.isToggle() && Input.is_action_just_released(config.getInputMap()):
					actions.push_back(config.getInputMap())
	return actions

func getInputMapActionsReleased(isBuilding: bool):
	var actions: Array[String] = []
	for inputs in getAllInputConfigs():
		for config in inputs:
			if !isBuilding || (isBuilding && config.canPressWhileBuilding()):
				if !config.isToggle() && Input.is_action_just_released(config.getInputMap()):
					actions.push_back(config.getInputMap())
	return actions

func find(name) -> InputConfiguration:
	if name is InputConfiguration:
		name = name.getName()
	
	assert(name is String, 'name should be a string or an InputConfiguration')
	
	for inputs in getAllInputConfigs():
		for config in inputs:
			if config.name == name:
				return config
	
	return null

func pressKey(action: String, value: int = -1) -> int:
	assert(action.begins_with('ui'), 'action should be the name of an Input action')
	
	for inputs in getAllInputConfigs():
		for config in inputs:
			if config.getInputMap() == action:
				if value == -1:
					config.next()
				else:
					config.setIndex(value)
				return config.getIndex()
			if config.getInputMapPrev() == action:
				if value == -1:
					config.prev()
				else:
					config.setIndex(value)
				return config.getIndex()
	
	return -1
