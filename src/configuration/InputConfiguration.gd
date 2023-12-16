class_name InputConfiguration

var name: String
var values: Array[String]
var index: int
var useValuesAsName: bool
var inputMap: String
var inputMapPrev: String = ""
var pressWhileBuilding: bool = false

func _init(name_: String):
	name = name_
	if name == "Pickup Items":
		values = ["on", "off"]
		index = 1
		useValuesAsName = false
		inputMap = "ui_pickup_item"
		
	if name == "Rotation":
		values = ["Rot: Up", "Rot: Right", "Rot: Down", "Rot: Left"]
		index = 0
		useValuesAsName = true
		inputMap = "ui_rotate_right"
		inputMapPrev = "ui_rotate_left"
		pressWhileBuilding = true
	
func next():
	index = (index + 1) % values.size()

func prev():
	index = (index - 1 + values.size()) % values.size()

func getName():
	return name
	
func getNItems():
	return values.size()

func getIndex():
	return index

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
