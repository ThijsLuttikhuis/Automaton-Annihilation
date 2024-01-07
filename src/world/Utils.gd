
class_name Utils

static func getResourceTexture(name):
	var texture: Texture2D
	if name == "Iron Ore":
		texture = preload("res://assets/resources/iron_ore.png")
	elif name == "Iron Plate":
		texture = preload("res://assets/resources/iron_plate.png") 
	elif name == "Iron Gear":
		texture = preload("res://assets/resources/iron_gear.png") 
	elif name == "Copper Ore":
		texture = preload("res://assets/resources/copper_ore.png")
	elif name == "Copper Plate":
		texture = preload("res://assets/resources/copper_plate.png")
	elif name == "Stone":
		texture = preload("res://assets/resources/stone.png")
	elif name == "Coal":
		texture = preload("res://assets/resources/coal.png")
	else:
		texture = preload("res://assets/resources/unknown_item.png")
	return texture

static func getKeyboardKeyFromInputMap(inputMapKey):
	var keyIndex = InputMap.action_get_events(inputMapKey)
	if keyIndex.is_empty():
		return "Unknown Key"
	var physicalKeyCode = DisplayServer.keyboard_get_keycode_from_physical(keyIndex[0].physical_keycode)
	var keycode = OS.get_keycode_string(physicalKeyCode)
	if keycode is String && !keycode.is_empty() && keycode.length() < 3:
		return keycode
	else:
		if keyIndex[0].keycode == KEY_ESCAPE:
			return "Esc"
		if keycode == "BraceRight":
			return "]"
		if keycode == "BraceLeft":
			return "["

	return "Unknown Key"
