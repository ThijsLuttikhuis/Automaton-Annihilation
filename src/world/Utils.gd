
class_name Utils


enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

static func buildStateToTabIndex(state):
	if state == BUILD_MENU.NONE:
		return 0
	elif state == BUILD_MENU.ECONOMY:
		return 1
	elif state == BUILD_MENU.DEFENSE:
		return 2
	elif state == BUILD_MENU.UTILITY:
		return 3
	elif state == BUILD_MENU.FACTORY:
		return 4
	else:
		assert(false, "invalid build menu state")
	
static func buildStateToString(state):
	if state == BUILD_MENU.ECONOMY:
		return "Economy"
	elif state == BUILD_MENU.DEFENSE:
		return "Defense"
	elif state == BUILD_MENU.UTILITY:
		return "Utility"
	elif state == BUILD_MENU.FACTORY:
		return "Factory"
	else:
		return "Unit"

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
		texture = preload("res://assets/prototype/energy.png")
	return texture

static func getKeyboardKeyFromInputMap(inputMapKey):
	var keyIndex = InputMap.action_get_events(inputMapKey)
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
	print(keycode)
	print(keyIndex[0].keycode)
	return "Unknown Key"
