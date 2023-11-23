extends Node

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

const MIN_DIST_BETWEEN_MOVE_POINTS = 5

var buildmenuState: BUILD_MENU = BUILD_MENU.NONE
var buildmenuBuilding: PackedScene = null
var isBuilding: bool = false

var mouseClickPath: Array[Vector2]
var collisionBox: CollisionShape2D

var selectedElements: Array[Unit]

func _ready():
	collisionBox = $"SelectBox/CollisionRectangle"
	var selectBox = $"SelectBox"
	selectBox.body_entered.connect(addSelectedElement)
	selectBox.body_exited.connect(removeSelectedElement)
	
func _process(_dt):
	updateSelectUnits()
	updateUIBuildmenu()
	updateActionQueue()

func updateSelectUnits():
	if Input.is_action_pressed("mouse_button_2"):
		# TODO: cancel
		return
	
	if Input.is_action_just_pressed("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		mouseClickPath.clear()
		mouseClickPath.push_back(mouseClickPosition)
		if buildmenuState != BUILD_MENU.NONE && buildmenuBuilding:
			isBuilding = true
		else:
			removeAllSelectedElements()
			setCollisionBoxTransform(mouseClickPosition, Vector2(0,0))
	
	if Input.is_action_pressed("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		var deltaPos = mouseClickPosition - mouseClickPath[0]
		mouseClickPath.push_back(mouseClickPosition)
		if isBuilding:
			pass
			# TODO: show blueprint of buildings that would be built
		else:	
			setCollisionBoxTransform((mouseClickPosition + mouseClickPath[0]) * 0.5, abs(deltaPos))
	
	if Input.is_action_just_released("mouse_button_1"):
		var mouseClickPosition = get_viewport().get_camera_2d().get_global_mouse_position()
		setCollisionBoxTransform(Vector2(9e9,9e9), Vector2(0,0))
		
		if isBuilding:

			var buildingsNode = $"../Buildings"
			var tileMapNode = $"../WorldTileMap"
			if Input.is_action_pressed("ui_push_back_queue"):
				pass
				# multi building in line

			elif Input.is_action_pressed("ui_push_front_queue"):
				pass
				# multi building in line
			else:
				var clickedCellIndex = tileMapNode.local_to_map(mouseClickPosition)
				var data = tileMapNode.get_cell_tile_data(1, clickedCellIndex)
				if data:
					return # cell occupied 
				
				var newBuilding = buildmenuBuilding.instantiate()
				buildingsNode.add_child(newBuilding)
				newBuilding.position = tileMapNode.map_to_local(clickedCellIndex)
				print("created ", newBuilding)
				isBuilding = false
				buildmenuState = BUILD_MENU.NONE
				buildmenuBuilding = null
		else:
			# selected a box
			if selectedElements.is_empty():
				return
				
			for element in selectedElements:
				print("selected elements: ", element.name)
			
			selectedElements.sort_custom(sortBySelectedActionPriority)
			var element = selectedElements[0]
			#TODO set highest prio element to show build queue in UI
	
func updateUIBuildmenu():
	if selectedElements.is_empty():
		buildmenuState = BUILD_MENU.NONE
		return
		
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
	
	if selectedElements.is_empty():
		return
	
	var element = selectedElements[0]
	
	if element is BuildUnit:
		for i in range(12):
			var uibmstr = "ui_buildmenu_" + str(i)
			if Input.is_action_just_pressed(uibmstr):
				print(buildmenuState, str(i))
				if buildmenuState == BUILD_MENU.ECONOMY:
					var buildings = element.actionList.buildingsEconomy
					if i < buildings.size():
						buildmenuBuilding = buildings[i];
						break

func updateActionQueue():
	if selectedElements.is_empty():
		return
	
	if Input.is_action_just_pressed("mouse_button_2"):
		mouseClickPath.clear()
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		buildmenuState = BUILD_MENU.NONE
		buildmenuBuilding = null
		
	if Input.is_action_pressed("mouse_button_2"):
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		
	if Input.is_action_just_released("mouse_button_2"):
		mouseClickPath.push_back(get_viewport().get_camera_2d().get_global_mouse_position())
		
		var element = selectedElements[0]
		if element is BuildUnit:
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

func convertToMoveActions(clickPath):
	var newMoveActions: Array[UnitAction] = []
	var minDistSq = MIN_DIST_BETWEEN_MOVE_POINTS * MIN_DIST_BETWEEN_MOVE_POINTS
	var cumulativeDistSq = minDistSq
	var previousPoint = clickPath[0]
	for point in clickPath:
		cumulativeDistSq += (previousPoint - point).length_squared()
		previousPoint = point
		if cumulativeDistSq >= minDistSq:
			var action = MoveAction.new(point)
			newMoveActions.push_back(action)
			cumulativeDistSq = 0
	return newMoveActions

func sortBySelectedActionPriority(a, b):
	return a.selectedActionPriority > b.selectedActionPriority
