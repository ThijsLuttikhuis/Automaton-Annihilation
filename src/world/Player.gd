class_name Player extends Node

const MIN_DIST_BETWEEN_MOVE_POINTS = 5

var world: Node
var hud: Node
var tileMap: Node

var rotationState: int = 0 # 0,1,2,3 => up,right,down,left
var buildmenuState: Utils.BUILD_MENU = Utils.BUILD_MENU.NONE
var buildmenuBuilding: PackedScene = null

var mousePosition: Vector2
var mouseClickPath: Array[Vector2]
var collisionBox: CollisionShape2D

var selectedUnits: Array[Unit]

func _ready():
	collisionBox = $"SelectBox/CollisionRectangle"
	var selectBox = $"SelectBox"
	selectBox.body_entered.connect(addSelectedUnit)
	selectBox.body_exited.connect(removeSelectedUnit)
	world = $".."
	hud = $"../HUD"
	tileMap = $"../WorldTileMap"
	
func _process(_dt):
	mousePosition = get_viewport().get_camera_2d().get_global_mouse_position()
	if buildmenuBuilding:
		if Input.is_action_just_pressed("mouse_button_2"):
			return
		if Input.is_action_pressed("mouse_button_2"):
			return
		if Input.is_action_just_released("mouse_button_2"):
			setBuildMenuState(Utils.BUILD_MENU.NONE)
			return
	
	updateRotation()
	updateSelectUnits()
	updateUIBuildmenu()
	updateActionQueue()
	updateGhosts()

func updateRotation():
	if Input.is_action_just_pressed("ui_rotate_right"):
		rotationState = (rotationState + 1) % 4
	
	if Input.is_action_just_pressed("ui_rotate_left"):
		rotationState = (rotationState + 3) % 4

func updateSelectUnits():
	if Input.is_action_just_pressed("mouse_button_1"):
		mouseClickPath.clear()
		mouseClickPath.push_back(mousePosition)
		if !buildmenuBuilding:
			removeAllSelectedUnits()
			setCollisionBoxTransform(mousePosition, Vector2(0,0))
	
	if Input.is_action_pressed("mouse_button_1"):
		var deltaPos = mousePosition - mouseClickPath[0]
		mouseClickPath.push_back(mousePosition)
		if !buildmenuBuilding:
			setCollisionBoxTransform((mousePosition + mouseClickPath[0]) * 0.5, abs(deltaPos))
	
	if Input.is_action_just_released("mouse_button_1"):
		setCollisionBoxTransform(Vector2(9e9,9e9), Vector2(0,0))
		
		if buildmenuBuilding:
			var unit = getMainSelectedUnit()
			if unit is BuildUnit:
				var newBuildActions = convertToBuildActions()
				pushToActionQueue(unit, newBuildActions)
				setBuildMenuState(Utils.BUILD_MENU.NONE)
		else:
			# selected a box
			if selectedUnits.is_empty():
				setBuildMenuState(Utils.BUILD_MENU.NONE)
				return
				
			for unit in selectedUnits:
				print("selected elements: ", unit.name)
			
			selectedUnits.sort_custom(sortBySelectedActionPriority)
			var unit = getMainSelectedUnit()
			hud.updateBuildMenuPanel(buildmenuState)
			#TODO set highest prio unit to show build queue in UI
		
		mouseClickPath.clear()
		
func updateUIBuildmenu():
	if selectedUnits.is_empty():
		return
		
	if Input.is_action_just_pressed("ui_cancel"):
		setBuildMenuState(Utils.BUILD_MENU.NONE)
		return
	
	if buildmenuState == Utils.BUILD_MENU.NONE:
		if Input.is_action_just_pressed("ui_buildmenu_economy"):
			setBuildMenuState(Utils.BUILD_MENU.ECONOMY)
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_defense"):
			setBuildMenuState(Utils.BUILD_MENU.DEFENSE)
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_utility"):
			setBuildMenuState(Utils.BUILD_MENU.UTILITY)
			print(buildmenuState)
			return
			
		if Input.is_action_just_pressed("ui_buildmenu_factory"):
			setBuildMenuState(Utils.BUILD_MENU.FACTORY)
			print(buildmenuState)
			return
	
	var unit = getMainSelectedUnit()
	if unit is BuildUnit:
		for i in range(12):
			var uibmstr = "ui_buildmenu_" + str(i)
			if Input.is_action_just_pressed(uibmstr):
				print(buildmenuState, str(i))
				var buildings = unit.getBuildActionList(buildmenuState)
				if i < buildings.size():
					buildmenuBuilding = buildings[i];
					hud.updateBuildMenuPanel(buildmenuState)
					break

func updateActionQueue():
	if selectedUnits.is_empty():
		return
	
	if Input.is_action_just_pressed("mouse_button_2"):
		mouseClickPath.clear()
		mouseClickPath.push_back(mousePosition)
		setBuildMenuState(Utils.BUILD_MENU.NONE)
		
	if Input.is_action_pressed("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
	if Input.is_action_just_released("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
		var unit = getMainSelectedUnit()
		if unit is BuildUnit:
			var newMoveActions = convertToMoveActions()
			pushToActionQueue(unit, newMoveActions)
		mouseClickPath.clear()
		
func updateGhosts():
	var ghostBuildingsNode = $"../GhostBuildings"

	var ghostBuildings = ghostBuildingsNode.get_children()
	if !buildmenuBuilding:
		for ghostBuilding in ghostBuildings:
			if !ghostBuilding.is_queued_for_deletion():
				ghostBuilding.queue_free()
		return
	
	# use mouse path if dragging and shift / space
	var mouseStartPoint: Vector2
	var mouseEndPoint: Vector2
	mouseEndPoint = mousePosition
	if mouseClickPath.size() >= 2 && Input.is_action_pressed("mouse_button_1") && \
		(Input.is_action_pressed("ui_push_back_queue") || Input.is_action_pressed("ui_push_front_queue")):
		mouseStartPoint = mouseClickPath[0]
	else:
		mouseStartPoint = mousePosition
		
	var startCellIndex = tileMap.local_to_map(mouseStartPoint)
	var endCellIndex = tileMap.local_to_map(mouseEndPoint)
	
	# check number of ghosts to place
	var dxCell: int = endCellIndex.x - startCellIndex.x
	var dyCell: int = endCellIndex.y - startCellIndex.y 
	var nGhosts: int
	if abs(dxCell) > abs(dyCell):
		nGhosts = abs(dxCell) + 1
	else:
		nGhosts = abs(dyCell) + 1
	
	# check if we still have the same building, and update rotation
	for i in range(ghostBuildings.size()):
		if ghostBuildings[i].hasRotation:
			ghostBuildings[i].get_node("Sprite2D").frame = rotationState
		
		var testBuilding = buildmenuBuilding.instantiate()
		if testBuilding.name.length() <= ghostBuildings[i].name.length():
			if testBuilding.name == ghostBuildings[i].name.substr(0, testBuilding.name.length()):
				continue
		ghostBuildings[i].queue_free()
	
	# add or remove ghost buildings to equalize nGhosts
	if nGhosts > ghostBuildings.size():
		for i in range(nGhosts - ghostBuildings.size()):
			var newBuilding = buildmenuBuilding.instantiate()
			ghostBuildingsNode.add_child(newBuilding, true)
			newBuilding.setGhost()
	else:
		for i in range(ghostBuildings.size() - nGhosts):
			ghostBuildings[-1].queue_free()
			
	ghostBuildings = ghostBuildingsNode.get_children() #reload

	# update ghost positions
	if nGhosts == 1:
		ghostBuildings[0].position = tileMap.map_to_local(endCellIndex)
	else:
		for i in range(nGhosts):
			var cellI: Vector2i
			if abs(dxCell) > abs(dyCell):
				cellI = Vector2i(startCellIndex.x + sign(dxCell) * i, \
					startCellIndex.y + round(float(i) * dyCell / abs(dxCell)))
			else:
				cellI = Vector2i(startCellIndex.x + round(float(i) * dxCell / abs(dyCell)), \
					startCellIndex.y + sign(dyCell) * i)
			
			ghostBuildings[i].position = tileMap.map_to_local(cellI)
	
	# check illegal ghost position
	for ghostBuilding in ghostBuildings:
		var cellI = tileMap.local_to_map(ghostBuilding.position)
		if !ghostBuilding.canBuildOnTile(cellI):
			ghostBuilding.queue_free()
		
	
func addSelectedUnit(unit):
	if Input.is_action_pressed("mouse_button_1"):
		if unit is Unit:
			unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0.5)
			selectedUnits.push_back(unit)
	hud.updateBuildMenuPanel(buildmenuState)
	
func removeSelectedUnit(unit):
	if Input.is_action_pressed("mouse_button_1"):
		if unit is Unit:
			unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
			selectedUnits.erase(unit)
	hud.updateBuildMenuPanel(buildmenuState)

func removeAllSelectedUnits():
	for unit in selectedUnits:
		unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
	selectedUnits.clear();
	hud.updateBuildMenuPanel(buildmenuState)
	
func setCollisionBoxTransform(pos, size):
	collisionBox.position = pos
	collisionBox.shape.size = size
	collisionBox.get_node("Sprite2D").position = size * 0.5
	collisionBox.get_node("Sprite2D").scale = size

func convertToMoveActions():
	var newMoveActions: Array[UnitAction] = []
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

func convertToBuildActions():
	var newBuildActions: Array[UnitAction] = []
	var ghostBuildingsNode = $"../GhostBuildings"
	var ghostBuildingsActionQueueNode = $"../ActionGhostBuildings"
	
	var ghostBuildings = ghostBuildingsNode.get_children()
	for ghostBuilding in ghostBuildings:
		if ghostBuilding.is_queued_for_deletion():
			continue
		
		ghostBuilding.reparent(ghostBuildingsActionQueueNode)
		var action = BuildAction.new(ghostBuilding.position, ghostBuilding)
		newBuildActions.push_back(action)
	return newBuildActions
		
func pushToActionQueue(unit, newActions):
	var actionQueue = unit.get_node("ActionQueue")
	if Input.is_action_pressed("ui_push_back_queue"):
		actionQueue.push_back(newActions)
	elif Input.is_action_pressed("ui_push_front_queue"):
		actionQueue.push_front(newActions)
	else:
		actionQueue.clear()
		actionQueue.push_back(newActions)

func sortBySelectedActionPriority(a, b):
	return a.selectedActionPriority > b.selectedActionPriority

func getMainSelectedUnit():
	if selectedUnits.is_empty():
		return null
	else:
		return selectedUnits[0]

func setBuildMenuState(state: Utils.BUILD_MENU):
	buildmenuState = state
	if state == Utils.BUILD_MENU.NONE:
		buildmenuBuilding = null
	hud.updateBuildMenuPanel(buildmenuState)
