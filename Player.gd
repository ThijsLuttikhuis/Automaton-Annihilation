extends Node

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

var buildmenuState: BUILD_MENU = BUILD_MENU.NONE
var mouseClickStartPosition: Vector2
var collisionBox: CollisionShape2D

var selectedElements: Array[Unit]

func _ready():
	collisionBox = get_node("SelectBox/CollisionRectangle")

func _process(_dt):
	updateSelectUnits()
	updateUIBuildmenu()
	updateActionQueue()

func updateSelectUnits():
	if Input.is_action_just_pressed("mouse_button_1"):
		selectedElements.clear()
		mouseClickStartPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		collisionBox.position = mouseClickStartPosition
		collisionBox.shape.size = Vector2(0,0)
	
	if Input.is_action_pressed("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		var deltaPos = mouseClickPosition - mouseClickStartPosition
		collisionBox.position = (mouseClickPosition + mouseClickStartPosition) * 0.5
		collisionBox.shape.size = abs(deltaPos)
	
	if Input.is_action_just_released("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		collisionBox.position = mouseClickPosition
		collisionBox.shape.size = Vector2(0,0)
		
		for element in selectedElements:
			print(element.name)
			
			

func updateUIBuildmenu():
	if buildmenuState == BUILD_MENU.NONE:
		if Input.is_action_just_pressed("ui_cancel"):
			buildmenuState = BUILD_MENU.NONE
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_economy"):
			buildmenuState = BUILD_MENU.ECONOMY
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_defense"):
			buildmenuState = BUILD_MENU.DEFENSE
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_utility"):
			buildmenuState = BUILD_MENU.UTILITY
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_factory"):
			buildmenuState = BUILD_MENU.FACTORY
			print(buildmenuState)
			return

func updateActionQueue():
	print(selectedElements.size())
	if selectedElements.is_empty():
		return
	
	var element = selectedElements[0]
	# sort selectedElements by element.selectedActionPriority
	
	if Input.is_action_just_released("mouse_button_2"):
		var targetPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		var action = MoveAction.new(targetPosition)

		var actionQueue = element.get_node("ActionQueue")
		if Input.is_action_pressed("ui_push_back_queue"):
			actionQueue.push_back(action)
		elif Input.is_action_pressed("ui_push_front_queue"):
			actionQueue.push_front(action)
		else:
			actionQueue.clear()
			actionQueue.push_back(action)

func addSelectedElement(body):
	if Input.is_action_pressed("mouse_button_1"):
		selectedElements.push_back(body)
	
func removeSelectedElement(body):
	if Input.is_action_pressed("mouse_button_1"):
		selectedElements.erase(body)

