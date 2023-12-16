class_name HUD extends CanvasLayer

const updateTime = 0.1

var world: World
var player: Player

var selectUnitPanel: Container
var worldStatePanel: Container
var inputConfigPanel: Container

var lastUnit: Unit

func _ready():
	world = $".."
	player = $"../Player"
	worldStatePanel = $"WorldStateColor/WorldStatePanel"
	selectUnitPanel = $"SelectUnitColor/SelectUnitPanel"
	inputConfigPanel = $"SelectInputColor/InputConfiguration"
	
	createBuildingUITabs()
	createBuildMenuTabLabels()
	createConfigurationGrid()

func _unhandled_input(event):
	if event:
		updateEnergyPanel()
		updateSelectedUnitPanel()

func _physics_process(dt):
	if fmod(world.getTime(), updateTime) < dt:
		updateEnergyPanel()
		updateSelectedUnitPanel()

func updateSelectedUnitPanel():
	var unit = player.getMainSelectedUnit()
	if !unit:
		lastUnit = null
		selectUnitPanel.get_parent().hide()
		inputConfigPanel.get_parent().hide()
		return
		
	selectUnitPanel.get_parent().show()
	inputConfigPanel.get_parent().show()
	
	updateBuildMenuPanel(unit)
	updateConfigurationPanel(unit)
	
func createConfigurationGrid():
	var children = [inputConfigPanel.get_node("InputBuild"), \
		inputConfigPanel.get_node("InputCombat"), \
		inputConfigPanel.get_node("InputGeneral")]
		
	for child in children:
		var inputUIScene = preload("res://src/ui/ConfigurationUI.tscn")
		
		for i in range(5):
			var inputUI = inputUIScene.instantiate()
			inputUI.name = "InputUI" + str(i)
			child.add_child(inputUI)

func createBuildingUITabs():
	for child in selectUnitPanel.get_children():
		if child.name == "Unit":
			continue
		
		var buildingUIScene = preload("res://src/ui/BuildingUI.tscn")
		var order = [8,9,10,11,4,5,6,7,0,1,2,3]

		for i in order:
			var buildingUI = buildingUIScene.instantiate()
			buildingUI.name = "Building" + str(i)
			var labelKeyboardKey = buildingUI.get_node("BuildingUI/ClipContentNode/TextureRect/Label")
			
			labelKeyboardKey.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_" + str(i))
			child.add_child(buildingUI)


	
func updateEnergyPanel():
	var energy = world.getEnergy()
	var energyStorage = world.getEnergyStorage()
	var energyDisplay = worldStatePanel.get_node("EnergyDisplay")
	energyDisplay.text = "Energy: " + str(round(energy)) + " / " + str(round(energyStorage))
	
	var windSpeed = world.getWindSpeed()
	var windSpeedDisplay = worldStatePanel.get_node("WindSpeedDisplay")
	windSpeedDisplay.text = "Wind Speed: " + str(round(windSpeed * 10.0) / 10.0)
	
	var solarPower = world.getSolarPower()
	var solarPowerDisplay = worldStatePanel.get_node("SolarPowerDisplay")
	solarPowerDisplay.text = "Solar Power: " + str(round(solarPower * 10.0) / 10.0)
	
func updateBuildMenuPanel(unit):
	var buildMenuState = player.getBuildmenuState()
	var stateIndex = Utils.buildStateToTabIndex(buildMenuState)
	selectUnitPanel.set_current_tab(stateIndex)
	
	updateBuildMenuPanelKeyboardLabels(stateIndex)
	updateBuildMenuSelectedTab(unit, stateIndex)

func updateConfigurationPanel(unit):
	if !(unit is BuildUnit):
		pass
	
	var inputConfigs = [inputConfigPanel.get_node("InputBuild"), \
		inputConfigPanel.get_node("InputCombat"), \
		inputConfigPanel.get_node("InputGeneral")]
		
	var inputConfigurationList = unit.inputConfigurationList
	var configLists = [inputConfigurationList.inputBuild, \
		inputConfigurationList.inputCombat, \
		inputConfigurationList.inputGeneral]
	
	for i in range(3):
		var children = inputConfigs[i].get_children()
		var configList = configLists[i]
		for j in range(5):
			var uiChild = children[j]
			if configList.size() <= j:
				uiChild.hide()
				continue
			
			uiChild.show()

			var config = configList[j]
			uiChild.get_node("Button").inputConfig = config
			uiChild.get_node("Configuration/Name").text = config.getNametag()
			uiChild.get_node("Configuration/SliderColor").self_modulate = config.getColor()
			uiChild.get_node("Configuration/SliderColor/Slider").value = config.getIndex()
			uiChild.get_node("Configuration/SliderColor/Slider").max_value = config.getNItems() - 1
			uiChild.get_node("Configuration/Spacer/KeyColor").visible = \
				config.canPressWhileBuilding() || (player.getBuildmenuState() == Utils.BUILD_MENU.NONE)
			uiChild.get_node("Configuration/Spacer/KeyColor/KeyboardKey").text = \
				Utils.getKeyboardKeyFromInputMap(config.getInputMap())

func createBuildMenuTabLabels():
	var unitLabel = $"SelectUnitColor/UnitTabLabel/Label"
	unitLabel.text = Utils.getKeyboardKeyFromInputMap("ui_cancel")
	
	var economyLabel = $"SelectUnitColor/EconomyTabLabel/Label"
	economyLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_economy")
	
	var defenseLabel = $"SelectUnitColor/DefenseTabLabel/Label"
	defenseLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_defense")
	
	var utilityLabel = $"SelectUnitColor/UtilityTabLabel/Label"
	utilityLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_utility")
	
	var factoryLabel = $"SelectUnitColor/FactoryTabLabel/Label"
	factoryLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_factory")

func updateBuildMenuPanelKeyboardLabels(stateIndex):
	var unitLabel = $"SelectUnitColor/UnitTabLabel"
	unitLabel.visible = stateIndex != 0
	
	var economyLabel = $"SelectUnitColor/EconomyTabLabel"
	economyLabel.visible = stateIndex == 0
	
	var defenseLabel = $"SelectUnitColor/DefenseTabLabel"
	defenseLabel.visible = stateIndex == 0
	
	var utilityLabel = $"SelectUnitColor/UtilityTabLabel"
	utilityLabel.visible = stateIndex == 0
	
	var factoryLabel = $"SelectUnitColor/FactoryTabLabel"
	factoryLabel.visible = stateIndex == 0

func updateBuildMenuSelectedTab(unit, stateIndex):
	if stateIndex == 0:
		updateUnitInfoPanel(unit)
	else:
		updateUnitBuildMenu(unit, stateIndex)

func updateUnitInfoPanel(unit):
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

func updateUnitBuildMenu(unit, stateIndex):
	if !(unit is BuildUnit):
		return
	
	var actionList = unit.buildActionList
	var buildStr = ["Economy", "Defense", "Utility", "Factory"]
	var buildLists = [actionList.buildingsEconomy, actionList.buildingsDefense, \
		actionList.buildingsUtility, actionList.buildingsFactory]
	
	var i = stateIndex - 1
	var buildList = buildLists[i]
	var grid = selectUnitPanel.get_node(buildStr[i])
	
	var selectedBuildingScene = player.getBuildmenuBuilding()
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

func updateGridElementTexture(gridElement, building):
	var sprite2D = building.get_node("Sprite2D")
	var nodeTexture = gridElement.get_node("ClipContentNode/Texture")
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
