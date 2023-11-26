class_name Player extends Node

enum BUILD_MENU {NONE, ECONOMY, DEFENSE, UTILITY, FACTORY}

const MIN_DIST_BETWEEN_MOVE_POINTS = 5

var buildmenuState: BUILD_MENU = BUILD_MENU.NONE
var buildmenuBuilding: PackedScene = null
var ghostBuildings: Array[Node]

var mousePosition: Vector2
var mouseClickPath: Array[Vector2]
var collisionBox: CollisionShape2D

var selectedElements: Array[Unit]

func _ready():
	collisionBox = $"SelectBox/CollisionRectangle"
	var selectBox = $"SelectBox"
	selectBox.body_entered.connect(addSelectedElement)
	selectBox.body_exited.connect(removeSelectedElement)
	
func _process(_dt):
	if buildmenuBuilding:
		if Input.is_action_just_pressed("mouse_button_2"):
			return
		if Input.is_action_pressed("mouse_button_2"):
			return
		if Input.is_action_just_released("mouse_button_2"):
			buildmenuState = BUILD_MENU.NONE
			buildmenuBuilding = null
			return
	
	mousePosition = get_viewport().get_camera_2d().get_global_mouse_position()
	updateSelectUnits()
	updateUIBuildmenu()
	updateActionQueue()
	updateVisuals()

func updateSelectUnits():
	if Input.is_action_just_pressed("mouse_button_1"):
		mouseClickPath.clear()
		mouseClickPath.push_back(mousePosition)
		if !buildmenuBuilding:
			removeAllSelectedElements()
			setCollisionBoxTransform(mousePosition, Vector2(0,0))
	
	if Input.is_action_pressed("mouse_button_1"):
		var deltaPos = mousePosition - mouseClickPath[0]
		mouseClickPath.push_back(mousePosition)
		if !buildmenuBuilding:
			setCollisionBoxTransform((mousePosition + mouseClickPath[0]) * 0.5, abs(deltaPos))
	
	if Input.is_action_just_released("mouse_button_1"):
		setCollisionBoxTransform(Vector2(9e9,9e9), Vector2(0,0))
		
		if buildmenuBuilding:
			var buildingsNode = $"../Buildings"
			var ghostBuildingsNode = $"../GhostBuildings"
			var tileMapNode = $"../WorldTileMap"
			if Input.is_action_pressed("ui_push_back_queue"):
				buildmenuState = BUILD_MENU.NONE
				buildmenuBuilding = null
				pass
				# multi building in line

			elif Input.is_action_pressed("ui_push_front_queue"):
				buildmenuState = BUILD_MENU.NONE
				buildmenuBuilding = null
				pass
				# multi building in line
			else:
				var clickedCellIndex = tileMapNode.local_to_map(mousePosition)
				var data = tileMapNode.get_cell_tile_data(1, clickedCellIndex)
				if data:
					return # cell occupied 
				
				# add building as actionqueue item
				var newBuilding = buildmenuBuilding.instantiate()
				buildingsNode.add_child(newBuilding)
				newBuilding.position = tileMapNode.map_to_local(clickedCellIndex)
				print("created ", newBuilding)
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
		mouseClickPath.clear()
		
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
		mouseClickPath.push_back(mousePosition)
		buildmenuState = BUILD_MENU.NONE
		buildmenuBuilding = null
		
	if Input.is_action_pressed("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
	if Input.is_action_just_released("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
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
		mouseClickPath.clear()
		
func updateVisuals():
	if !buildmenuBuilding:
		for ghostBuilding in ghostBuildings:
			if is_instance_valid(ghostBuilding):
				ghostBuilding.queue_free()
		return
	
	var ghostBuildingsNode = $"../GhostBuildings"
	var tileMapNode = $"../WorldTileMap"
	
	var mouseStartPoint: Vector2
	var mouseEndPoint: Vector2
	
	mouseEndPoint = mousePosition
	if mouseClickPath.size() >= 2 && Input.is_action_pressed("mouse_button_1") && \
		(Input.is_action_pressed("ui_push_back_queue") || Input.is_action_pressed("ui_push_front_queue")):
		mouseStartPoint = mouseClickPath[0]
	else:
		mouseStartPoint = mousePosition
		
	var startCellIndex = tileMapNode.local_to_map(mouseStartPoint)
	var endCellIndex = tileMapNode.local_to_map(mouseEndPoint)
	
	# make line from start to end
	var dxCell: int = endCellIndex.x - startCellIndex.x
	var dyCell: int = endCellIndex.y - startCellIndex.y 
	var nGhosts: int
	# check number of ghosts to place
	if abs(dxCell) > abs(dyCell):
		nGhosts = abs(dxCell) + 1
	else:
		nGhosts = abs(dyCell) + 1
		
	# add or remove ghost buildings to equalize nGhosts
	ghostBuildings = ghostBuildingsNode.get_children()
	if nGhosts > ghostBuildings.size():
		for i in range(nGhosts - ghostBuildings.size()):
			var newBuilding = buildmenuBuilding.instantiate()
			ghostBuildingsNode.add_child(newBuilding)
			newBuilding.makeGhost()
	else:
		for i in range(ghostBuildings.size() - nGhosts):
			ghostBuildings[-1].queue_free()
			
	ghostBuildings = ghostBuildingsNode.get_children() #reload

	if nGhosts == 1:
		ghostBuildings[0].position = tileMapNode.map_to_local(endCellIndex)
	else:
		for i in range(nGhosts):
			var cellI: Vector2i
			if abs(dxCell) > abs(dyCell):
				cellI = Vector2i(startCellIndex.x + sign(dxCell) * i, \
					startCellIndex.y + round(float(i) * dyCell / abs(dxCell)))
			else:
				cellI = Vector2i(startCellIndex.x + round(float(i) * dxCell / abs(dyCell)), \
					startCellIndex.y + sign(dyCell) * i)
			
			
			ghostBuildings[i].position = tileMapNode.map_to_local(cellI)



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
