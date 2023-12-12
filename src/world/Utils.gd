
class_name Utils

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

static func buildStateToTabIndex(state):
	if state == BUILD_MENU.ECONOMY:
		return 1
	elif state == BUILD_MENU.DEFENSE:
		return 2
	elif state == BUILD_MENU.UTILITY:
		return 3
	elif state == BUILD_MENU.FACTORY:
		return 4
	else:
		return 0
	
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
		texture = preload("res://assets/prototype/resources/iron_ore.png")
	elif name == "Iron Plate":
		texture = preload("res://assets/prototype/resources/iron_plate.png") 
	elif name == "Copper Ore":
		texture = preload("res://assets/prototype/resources/copper_ore.png")
	elif name == "Copper Plate":
		texture = preload("res://assets/prototype/resources/copper_plate.png")
	elif name == "Stone":
		texture = preload("res://assets/prototype/resources/stone.png")
	else:
		texture = preload("res://assets/prototype/energy.png")
	return texture

