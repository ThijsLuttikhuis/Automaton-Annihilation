extends Node

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

const MIN_DIST_BETWEEN_MOVE_POINTS = 5

var buildmenuState: BUILD_MENU = BUILD_MENU.NONE
var mouseClickPath: Array[Vector2]
var collisionBox: CollisionShape2D

var selectedElements: Array[Unit]

func _ready():
	collisionBox = get_node("SelectBox/CollisionRectangle")

func _process(_dt):
	updateSelectUnits()
	updateUIBuildmenu()
	updateActionQueue()

func updateSelectUnits():
	if Input.is_action_pressed("mouse_button_2"):
		return
	
	if Input.is_action_just_pressed("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		removeAllSelectedElements()
		mouseClickPath.clear()
		mouseClickPath.push_back(mouseClickPosition)
		setCollisionBoxTransform(mouseClickPosition, Vector2(0,0))
	
	if Input.is_action_pressed("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		var deltaPos = mouseClickPosition - mouseClickPath[0]
		mouseClickPath.push_back(mouseClickPosition)
		setCollisionBoxTransform((mouseClickPosition + mouseClickPath[0]) * 0.5, abs(deltaPos))
	
	if Input.is_action_just_released("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		setCollisionBoxTransform(Vector2(9e9,9e9), Vector2(0,0))
		
		for element in selectedElements:
			print(element.name)

func updateUIBuildmenu():
	if Input.is_action_just_pressed("ui_cancel"):
			buildmenuState = BUILD_MENU.NONE
			print(buildmenuState)
			return
			
	if buildmenuState == BUILD_MENU.NONE:
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
	if selectedElements.is_empty():
		return
	
	selectedElements.sort_custom(sortBySelectedActionPriority)
	var element = selectedElements[0]

	if Input.is_action_just_pressed("mouse_button_2"):
		mouseClickPath.clear()
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		
	if Input.is_action_pressed("mouse_button_2"):
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		
	if Input.is_action_just_released("mouse_button_2"):
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		
		var newMoveActions = convertToMoveActions(mouseClickPath)
		var actionQueue = element.get_node("ActionQueue")
		if Input.is_action_pressed("ui_push_back_queue"):
			actionQueue.push_back(newMoveActions)
		elif Input.is_action_pressed("ui_push_front_queue"):
			actionQueue.push_front(newMoveActions)
		else:
			actionQueue.clear()
			actionQueue.push_back(newMoveActions)

func addSelectedElement(element):
	if Input.is_action_pressed("mouse_button_1"):
		element.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0.5)
		selectedElements.push_back(element)
	
func removeSelectedElement(element):
	if Input.is_action_pressed("mouse_button_1"):
		element.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
		selectedElements.erase(element)

func removeAllSelectedElements():
	for element in selectedElements:
		element.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
	selectedElements.clear();
	
func setCollisionBoxTransform(pos, size):
	collisionBox.position = pos
	collisionBox.shape.size = size
	collisionBox.get_node("Sprite2D").position = size * 0.5
	collisionBox.get_node("Sprite2D").scale = size

func convertToMoveActions(mouseClickPath):
	var newMoveActions: Array[UnitAction]
	var minDistSq = MIN_DIST_BETWEEN_MOVE_POINTS * MIN_DIST_BETWEEN_MOVE_POINTS
	var cumulativeDistSq = minDistSq
	var previousPoint = mouseClickPath[0]
	for point in mouseClickPath:
		cumulativeDistSq += (previousPoint - point).length_squared()
		previousPoint = point
		if cumulativeDistSq >= minDistSq:
			var action = MoveAction.new(point)
			newMoveActions.push_back(action)
			cumulativeDistSq = 0
	return newMoveActions

func sortBySelectedActionPriority(a, b):
	return a.selectedActionPriority > b.selectedActionPriority
