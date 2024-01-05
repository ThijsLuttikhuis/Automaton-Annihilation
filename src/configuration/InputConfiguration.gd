class_name InputConfiguration

var name: String
var values: Array[String]
var index: int
var useValuesAsName: bool
var inputMap: String
var inputMapPrev: String = ""
var pressWhileBuilding: bool = false
var toggle: bool = true

func _init(name_: String):
	name = name_
	if name == "Pickup Items":
		values = ["off", "on"]
		index = 1
		useValuesAsName = false
		inputMap = "ui_pickup_item"
	elif name == "Rotation":
		values = ["Rot: Up", "Rot: Right", "Rot: Down", "Rot: Left"]
		index = 0
		useValuesAsName = true
		inputMap = "ui_rotate_right"
		inputMapPrev = "ui_rotate_left"
		pressWhileBuilding = true
	elif name == "Chest Pickup":
		values = ["Needed Only", "Get Stack", "Get All"]
		index = 1
		useValuesAsName = false
		inputMap = "ui_pickup_chest"
		pressWhileBuilding = true
	elif name == "Demolish":
		values = ["off", "on"]
		index = 0
		useValuesAsName = false
		inputMap = "ui_demolish"
		toggle = false
	elif name == "Place Items":
		values = ["disabled", "custom", "anywhere"]
		pressWhileBuilding = true
		index = 1
		useValuesAsName = false
		inputMap = "ui_place_item_mode"
	elif name == "Chest Prio":
		values = ["disabled", "0", "1", "2"]
		pressWhileBuilding = true
		index = 3
		useValuesAsName = false
		inputMap = "ui_place_item_chest"
	elif name == "Conveyor Prio":
		values = ["disabled", "0", "1", "2"]
		pressWhileBuilding = true
		index = 2
		useValuesAsName = false
		inputMap = "ui_place_item_conveyor"
	elif name == "Other Prio":
		values = ["disabled", "0", "1", "2"]
		pressWhileBuilding = true
		index = 1
		useValuesAsName = false
		inputMap = "ui_place_item_other"
	else:
		print("UNKNOWN INPUT CONFIGURATION: ", name)
		values = ["off", "on"]
		index = 0
		useValuesAsName = true
		inputMap = "ui_"

func next():
	index = (index + 1) % values.size()

func prev():
	index = (index - 1 + values.size()) % values.size()

func getName():
	return name

func isToggle():
	return toggle

func getValue():
	return values[index]

func getNItems():
	return values.size()

func getIndex():
	return index

func setIndex(index_):
	assert(index >= 0 && index < values.size(), 'InputConfiguration:setIndex: index out of range')
	index = index_

func getNametag():
	if useValuesAsName:
		return values[index]
	else:
		return name

func canPressWhileBuilding():
	return pressWhileBuilding
	
func getColor():
	var frac = float(index) / (values.size() - 1)
	return Color(0.5, frac, 0.0)

func getInputMap():
	return inputMap

func getInputMapPrev():
	return inputMapPrev
