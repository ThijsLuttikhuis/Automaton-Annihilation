class_name HUD extends CanvasLayer

var world: World
var player: Player
var selectUnitPanel: Container
var worldStatePanel: Container

var lastUnit: Unit

func _ready():
	world = $".."
	player = $"../Player"
	worldStatePanel = $"WorldStateColor/WorldStatePanel"
	selectUnitPanel = $"SelectUnitColor/SelectUnitPanel"
	
	for child in selectUnitPanel.get_children():
		if child.name == "Unit":
			continue
		
		var buildingUIScene = preload("res://src/ui/BuildingUI.tscn")
		var order = [8,9,10,11,4,5,6,7,0,1,2,3]
		for i in order:
			var buildingUI = buildingUIScene.instantiate()
			buildingUI.name = "Building" + str(i)
			child.add_child(buildingUI)
	
func _process(_dt):
	var energy = world.getEnergy()
	var energyStorage = world.getEnergyStorage()
	var energyDisplay = worldStatePanel.get_node("EnergyDisplay")
	energyDisplay.text = "Energy: " + str(round(energy)) + " / " + str(round(energyStorage))
	
	var windSpeed = world.getWindSpeed()
	var windSpeedDisplay = worldStatePanel.get_node("WindSpeedDisplay")
	windSpeedDisplay.text = "Wind Speed: " + str(round(windSpeed * 10.0) / 10.0)

func updateBuildMenuPanel(state):
	var unit = player.getMainSelectedUnit()
	
	if !unit:
		lastUnit = null
		selectUnitPanel.get_parent().hide()
		return
		
	selectUnitPanel.get_parent().show()
	
	var stateIndex = Utils.buildStateToTabIndex(state)
	selectUnitPanel.set_current_tab(stateIndex)
	
	if unit == lastUnit:
		return
	
	var unitGrid = selectUnitPanel.get_node("Unit")
	unitGrid.get_node("Label").text = unit.getDisplayName()
	

	var unitResources = unit.inventory.resources
	
	var inventoryGrid = unitGrid.get_node("Unit/Inventory")
	var gridSize = inventoryGrid.get_children().size()
	
	# equalize number of cells in grid
	if unitResources.size() > gridSize:
		var itemUIScene = preload("res://src/ui/ItemUI.tscn")
		for i in range(unitResources.size() - gridSize):
			var itemUI = itemUIScene.instantiate()
			inventoryGrid.add_child(itemUI)
	elif unitResources.size() < gridSize:
		for i in range(-unitResources.size() + gridSize):
			inventoryGrid.get_child(-1).queue_free()
	
	# set correct values per grid cell
	for i in range(unitResources.size()):
		var key = unitResources.keys()[i]
		var itemUI = inventoryGrid.get_child(i)
		itemUI.get_node("Value").text = str(unitResources[key])
		itemUI.get_node("Texture").texture = Utils.getResourceTexture(key)

	
	
	
	if unit is BuildUnit:
		var actionList = unit.buildActionList
		var buildStr = ["Economy", "Defense", "Utility", "Factory"] 
		var buildLists = [actionList.buildingsEconomy, actionList.buildingsDefense, \
			actionList.buildingsUtility, actionList.buildingsFactory]
		
		for i in range(4):
			var buildList = buildLists[i]
			var grid = selectUnitPanel.get_node(buildStr[i])
			
			var selectedBuildingScene = player.buildmenuBuilding
			for j in range(12):
				var gridElement = grid.get_node("Building" + str(j) + "/BuildingUI")
				if j >= buildList.size():
					gridElement.hide()
					continue
				
				gridElement.show()
				var buildingScene: PackedScene = buildList[j]
				var building: Building = buildingScene.instantiate()
				
				updateGridElementTexture(gridElement, building)
				updateGridElementCost(unit, gridElement, building)
				
				if !selectedBuildingScene || (selectedBuildingScene && buildingScene == selectedBuildingScene):
					gridElement.modulate = Color(1.0, 1.0, 1.0, 1.0)
				else:
					gridElement.modulate = Color(0.8, 0.8, 0.8, 0.8)
				
	
	print('updating unit panel')

func updateGridElementTexture(gridElement, building):
	var sprite2D = building.get_node("Sprite2D")
	var nodeTexture = gridElement.get_node("Texture")
	nodeTexture.texture = sprite2D.texture

func updateGridElementCost(unit, gridElement, building):
	gridElement.get_node("Cost/Energy/Value").text = str(building.energyCost)
	
	if world.hasEnergy(building.energyCost):
		gridElement.get_node("Cost/Energy/Value").self_modulate = Color(1,1,1)
	else:
		gridElement.get_node("Cost/Energy/Value").self_modulate = Color(0.8,0.2,0.2)
		
	var resourceCost = building.resourceCost.resources
	
	var resourceNames = resourceCost.keys()
	assert(resourceNames.size() < 3, 'hud:updateResourceCost: cannot show more than two unique resources in the cost')
	
	var r1Value: int = 0
	var r2Value: int = 0
	var r1Name: String = ""
	var r2Name: String = ""
	
	if resourceNames.size() > 1:
		r1Value = resourceCost[resourceNames[0]]
		r2Value = resourceCost[resourceNames[1]]
		if r2Value > r1Value:
			r1Value = resourceCost[resourceNames[1]]
			r2Value = resourceCost[resourceNames[0]]
			r1Name = resourceNames[1]
			r2Name = resourceNames[0]
		else:
			r1Name = resourceNames[0]
			r2Name = resourceNames[1]
	
	if resourceNames.size() == 1:
		r1Value = resourceCost[resourceNames[0]]
		r1Name = resourceNames[0]
		
	var resource1Node = gridElement.get_node("Cost/Resource1")
	var resource2Node = gridElement.get_node("Cost/Resource2")
	
	resource1Node.get_node("Value").text = str(r1Value) if r1Value > 0 else ""
	resource2Node.get_node("Value").text = str(r2Value) if r2Value > 0 else ""
	resource1Node.get_node("Texture").texture = Utils.getResourceTexture(r1Name) if r1Value > 0 else null
	resource2Node.get_node("Texture").texture = Utils.getResourceTexture(r2Name) if r2Value > 0 else null
	if unit.inventory.hasResources(r1Name, r1Value):
		resource1Node.get_node("Value").self_modulate = Color(1,1,1)
	else:
		resource1Node.get_node("Value").self_modulate = Color(0.8,0.2,0.2)
	if r2Name != "" && unit.inventory.hasResources(r2Name, r2Value):
		resource2Node.get_node("Value").self_modulate = Color(1,1,1)
	else:
		resource2Node.get_node("Value").self_modulate = Color(0.8,0.2,0.2)
