class_name ConfigurationUIButton extends Button

var inputConfig: InputConfiguration

func setInputConfiguration(inputConfig_: InputConfiguration):
	inputConfig = inputConfig_

func on_press():
	print('pressed button')
	if inputConfig.canPressWhileBuilding() || $"/root/World/Player".getBuildmenuTab() == 0:
		inputConfig.next()
