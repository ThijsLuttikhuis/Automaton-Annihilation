class_name Player extends Node

const MIN_DIST_BETWEEN_MOVE_POINTS: float = 5.0

@onready var world: World = $".."
@onready var hud: CanvasLayer = $"../HUD"
@onready var tileMap: WorldTileMap = $"../WorldTileMap"
@onready var collisionBox: CollisionShape2D = $"SelectBox/CollisionRectangle"

var buildmenuTab: int = 0
var buildmenuBuilding: PackedScene = null

var mouseOnHUDatJustPressed: bool = false
var mousePosition: Vector2
var mouseClickPath: Array[Vector2]
var selectedUnits: Array[Unit]

func _process(_dt):
	updateInputConfiguration()
	updateUIBuildmenu()
	updateMouseAction()
	updateGhosts()

func updateInputConfiguration():
	var mainUnit: Unit = getMainSelectedUnit()
	if !mainUnit:
		return
	
	var isInBuildmenu = (getBuildmenuTab() != 0)
	mainUnit.inputConfigurationList.update(selectedUnits, isInBuildmenu)
	
	if isInBuildmenu:
		return
		
	if getDemolishButton():
		buildmenuBuilding = preload("res://src/units/buildings/Demolish.tscn") 
	
func updateUIBuildmenu():
	if !getMainSelectedUnit():
		return
		
	if Input.is_action_just_pressed("ui_cancel"):
		setBuildmenuState(0)
		return
		
	var tab = getBuildmenuTab()
	if tab == 0:
		for i in range(1, 5):
			if Input.is_action_just_pressed(("ui_buildmenutab_" + str(i))):
				setBuildmenuState(i)
				print(i)
				return
		return
	
	for i in range(12):
		var uibmstr = "ui_buildmenu_" + str(i)
		if Input.is_action_just_pressed(uibmstr):
			print(tab, str(i))
			setBuildmenuBuilding(i)
			break

func updateMouseAction():
	mousePosition = get_viewport().get_camera_2d().get_global_mouse_position()
	
	if getBuildmenuTab() != 0 || getBuildmenuBuilding():
		if Input.is_action_just_pressed("mouse_button_2"):
			return
		if Input.is_action_pressed("mouse_button_2"):
			return
		if Input.is_action_just_released("mouse_button_2"):
			setBuildmenuState(0)
			return
	
	if Input.is_action_just_pressed("mouse_button_1"):
		if hud.isMouseOnHUD():
			mouseOnHUDatJustPressed = true
			return
		
		mouseOnHUDatJustPressed = false
		mouseClickPath.clear()
		mouseClickPath.push_back(mousePosition)
		
		if !getBuildmenuBuilding():
			removeAllSelectedUnits()
			setCollisionBoxTransform(mousePosition, Vector2(0,0))
	
	if mouseOnHUDatJustPressed:
		return
	
	if Input.is_action_pressed("mouse_button_1"):
		var deltaPos = mousePosition - mouseClickPath[0]
		mouseClickPath.push_back(mousePosition)
		if !getBuildmenuBuilding():
			setCollisionBoxTransform((mousePosition + mouseClickPath[0]) * 0.5, abs(deltaPos))
	
	if Input.is_action_just_released("mouse_button_1"):
		setCollisionBoxTransform(Vector2(9e9,9e9), Vector2(0,0))
		
		if getBuildmenuBuilding():
			var unit = getMainSelectedUnit()
			if unit is BuildUnit:
				var newBuildActions = convertToBuildActions(getDemolishButton())
				pushToActionQueue(unit, newBuildActions)
				setBuildmenuState(0)
		else:
			# selected a box
			if selectedUnits.is_empty():
				setBuildmenuState(0)
				return
				
			for unit in selectedUnits:
				print("selected elements: ", unit.name)
			
			selectedUnits.sort_custom(sortBySelectedActionPriority)
		
		mouseClickPath.clear()
	
	if !getMainSelectedUnit():
		return
	
	if Input.is_action_just_pressed("mouse_button_2"):
		mouseClickPath.clear()
		mouseClickPath.push_back(mousePosition)
		setBuildmenuState(0)
		
	if Input.is_action_pressed("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
	if Input.is_action_just_released("mouse_button_2"):
		mouseClickPath.push_back(mousePosition)
		
		var newMoveActions = convertToMoveActions()
		for unit in newMoveActions.keys():
			pushToActionQueue(unit, newMoveActions[unit])
		
		mouseClickPath.clear()
		
func updateGhosts():
	var ghostBuildingsNode = $"../GhostBuildings"
	var ghostBuildings = ghostBuildingsNode.get_children()
	
	if !getBuildmenuBuilding():
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
			ghostBuildings[i].get_node("Sprite2D").frame = \
				getMainSelectedUnit().inputConfigurationList.find("Rotation").index
		
		var testBuilding = getBuildmenuBuilding().instantiate()
		if testBuilding.name.length() <= ghostBuildings[i].name.length():
			if testBuilding.name == ghostBuildings[i].name.substr(0, testBuilding.name.length()):
				continue
		ghostBuildings[i].queue_free()
	
	# add or remove ghost buildings to equalize nGhosts
	if nGhosts > ghostBuildings.size():
		for i in range(nGhosts - ghostBuildings.size()):
			var newBuilding = getBuildmenuBuilding().instantiate()
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
		if !ghostBuilding.canBuildOnTile(cellI) && !(ghostBuilding is Demolish):
			ghostBuilding.queue_free()

func addSelectedUnit(unit):
	if Input.is_action_pressed("mouse_button_1"):
		if unit is Unit:
			unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0.5)
			selectedUnits.push_back(unit)

func removeSelectedUnit(unit):
	if Input.is_action_pressed("mouse_button_1"):
		if unit is Unit:
			unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
			selectedUnits.erase(unit)

func removeAllSelectedUnits():
	for unit in selectedUnits:
		unit.get_node("Sprite2D").material.set_shader_parameter("outline_width", 0)
	selectedUnits.clear()

func setCollisionBoxTransform(pos, size):
	collisionBox.position = pos
	collisionBox.shape.size = size
	collisionBox.get_node("Sprite2D").position = size * 0.5
	collisionBox.get_node("Sprite2D").scale = size

func convertToMoveActions():
	if !getMainSelectedUnit() || !(getMainSelectedUnit() is MoveUnit):
		return {}
	
	if mouseClickPath.is_empty():
		return {}
		
	var moveUnits: Array[MoveUnit] = []
	for unit in selectedUnits:
		if unit is MoveUnit:
			moveUnits.push_back(unit)
	
	var nMoveUnits = moveUnits.size()
	if nMoveUnits == 0:
		return {}
	if nMoveUnits == 1:
		return convertToMoveActionsOneUnit(moveUnits[0])
	if nMoveUnits > 1:
		return convertToMoveActionsMultipeUnits(moveUnits, nMoveUnits)

func convertToMoveActionsOneUnit(unit: MoveUnit):
	var moveActionsDict: Dictionary = {}
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
	moveActionsDict[unit] = newMoveActions
	return moveActionsDict

func convertToMoveActionsMultipeUnits(moveUnits: Array[MoveUnit], nMoveUnits: int):
	var moveActionsDict: Dictionary = {}
	var cumulativeDistArr: Array[float] = []
	var previousPoint = mouseClickPath[0]
	var previousCumulativeDist: float = 0.0
	for point in mouseClickPath:
		var cumulativeDist = previousCumulativeDist + (previousPoint - point).length()
		cumulativeDistArr.push_back(cumulativeDist)
		previousCumulativeDist = cumulativeDist
		previousPoint = point
	
	var totalDist = cumulativeDistArr[-1]
	var cumulativeDistIndex: int = 0
	for i in range(moveUnits.size()):
		var unit = moveUnits[i]
		var dividedLength = totalDist * i / (nMoveUnits - 1)
		while cumulativeDistArr[cumulativeDistIndex] < dividedLength:
			cumulativeDistIndex += 1
		
		var action = MoveAction.new(mouseClickPath[cumulativeDistIndex])
		var actionInArray: Array[UnitAction] = []
		actionInArray.push_back(action)
		moveActionsDict[unit] = actionInArray
	
	return moveActionsDict

func convertToBuildActions(toDemolishAction: bool = false):
	var newBuildActions: Array[UnitAction] = []
	var ghostBuildingsNode = $"../GhostBuildings"
	var ghostBuildingsActionQueueNode = $"../ActionGhostBuildings"
	
	var ghostBuildings = ghostBuildingsNode.get_children()
	for ghostBuilding in ghostBuildings:
		if ghostBuilding.is_queued_for_deletion():
			continue
		
		ghostBuilding.reparent(ghostBuildingsActionQueueNode)
		var action: UnitAction
		if toDemolishAction:
			action = DemolishAction.new(ghostBuilding.position, ghostBuilding)
		else:
			action = BuildAction.new(ghostBuilding.position, ghostBuilding)
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

func setBuildmenuState(buildmenuTab_: int):
	assert(buildmenuTab_ >= 0 && buildmenuTab_ < 5, 'buildmenu Tab should be between 0 and 4')
	buildmenuTab = buildmenuTab_
	if buildmenuTab == 0:
		buildmenuBuilding = null

func setBuildmenuBuilding(index: int):
	var unit = getMainSelectedUnit()
	var buildings = unit.getBuildActionList(getBuildmenuTab())
	if index < buildings.size():
		assert(buildings[index] is PackedScene || buildings[index] is Recipe, \
			'buildList should contain either a PackedScene or an Array[Inventory]')
		if buildings[index] is PackedScene:
			buildmenuBuilding = buildings[index]
		if buildings[index] is Recipe:
			setRecipe(unit, buildings[index])

func setRecipe(unit: ConvertResourceBuilding, recipe: Recipe):
	unit.recipe = recipe

func getBuildmenuTab():
	return buildmenuTab

func getBuildmenuBuilding():
	return buildmenuBuilding

func getDemolishButton() -> bool:
	if buildmenuBuilding && buildmenuBuilding.instantiate() is Demolish:
		return true
		
	var mainUnit = getMainSelectedUnit()
	if mainUnit:
		var demolishValue = mainUnit.inputConfigurationList.find("Demolish")
		if demolishValue:
			return demolishValue.getValue() == 'on'
	return false

