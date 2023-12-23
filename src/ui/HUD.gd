class_name HUD extends CanvasLayer

const updateTime = 0.1

var world: World
var player: Player

var selectUnitPanel: Container
var worldStatePanel: Container
var inputConfigPanel: Container

var mouseOnContainer: Array[bool] = [false, false, false]

var lastUnit: Unit

func _ready():
	world = $".."
	player = $"../Player"
	worldStatePanel = $"WorldStateColor/WorldStatePanel"
	selectUnitPanel = $"SelectUnitColor/SelectUnitPanel"
	inputConfigPanel = $"SelectInputColor/InputConfiguration"
	
	createBuildingUITabs()
	createBuildmenuTabLabels()
	createConfigurationGrid()

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
	
	updateBuildmenuPanel(unit)
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
		var craftItemUIScene = preload("res://src/ui/CraftItemUI.tscn")
		var order = [8,9,10,11,4,5,6,7,0,1,2,3]
		
		for i in order:
			var buildingUI = buildingUIScene.instantiate()
			buildingUI.name = "Building" + str(i)
			var buildinglabelKeyboardKey = buildingUI.get_node("BuildingUI/ClipContentNode/TextureRect/Label")
			buildinglabelKeyboardKey.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_" + str(i))
			child.add_child(buildingUI)
			var buildingUIButton = buildingUI.get_node("Button")
			buildingUIButton.button_up.connect(onPressBuildmenuBuilding.bind(i))
			
			var craftItemUI = craftItemUIScene.instantiate()
			craftItemUI.name = "CraftItem" + str(i)
			var craftItemLabelKeyboardKey = craftItemUI.get_node("CraftItemUI/EnergyCost/TextureRect/TextureRect/Label")
			craftItemLabelKeyboardKey.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenu_" + str(i))
			child.add_child(craftItemUI)
			var craftItemUIButton = craftItemUI.get_node("Button")
			craftItemUIButton.button_up.connect(onPressBuildmenuBuilding.bind(i))

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
	
func updateBuildmenuPanel(unit):
	var buildMenuTab = player.getBuildmenuTab()
	selectUnitPanel.set_current_tab(buildMenuTab)
	
	updateBuildmenuPanelKeyboardLabels(unit, buildMenuTab)
	updateBuildmenuSelectedTab(unit, buildMenuTab)

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
			uiChild.get_node("Button").tooltip_text = config.getValue()
			uiChild.get_node("Configuration/Name").text = config.getNametag()
			uiChild.get_node("Configuration/SliderColor").self_modulate = config.getColor()
			uiChild.get_node("Configuration/SliderColor/Slider").value = config.getIndex()
			uiChild.get_node("Configuration/SliderColor/Slider").max_value = config.getNItems() - 1
			uiChild.get_node("Configuration/Spacer/KeyColor").visible = \
				config.canPressWhileBuilding() || (player.getBuildmenuTab() == 0)
			uiChild.get_node("Configuration/Spacer/KeyColor/KeyboardKey").text = \
				Utils.getKeyboardKeyFromInputMap(config.getInputMap())

func createBuildmenuTabLabels():
	var unitLabel = $"SelectUnitColor/UnitTabLabel/Label"
	unitLabel.text = Utils.getKeyboardKeyFromInputMap("ui_cancel")
	
	var economyLabel = $"SelectUnitColor/EconomyTabLabel/Label"
	economyLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenutab_1")
	
	var defenseLabel = $"SelectUnitColor/DefenseTabLabel/Label"
	defenseLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenutab_2")
	
	var utilityLabel = $"SelectUnitColor/UtilityTabLabel/Label"
	utilityLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenutab_3")
	
	var factoryLabel = $"SelectUnitColor/FactoryTabLabel/Label"
	factoryLabel.text = Utils.getKeyboardKeyFromInputMap("ui_buildmenutab_4")

func updateBuildmenuPanelKeyboardLabels(unit, stateIndex):
	var tabNames = unit.buildActionList.tabNames
	for i in range(4):
		var tab = $"SelectUnitColor/SelectUnitPanel".get_child(i+1)
		if tabNames.size() <= i:
			tab.name = "           " + str(i)
		else:
			tab.name = tabNames[i]
	
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

func updateBuildmenuSelectedTab(unit, buildMenuTab):
	if buildMenuTab == 0:
		updateUnitInfoPanel(unit)
	else:
		updateUnitBuildmenu(unit, buildMenuTab)

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
		itemUI.get_node("Texture").tooltip_text = key
		
func updateUnitBuildmenu(unit, buildMenuTab):
	var actionList = unit.buildActionList

	var buildLists = [actionList.units0, actionList.units1, \
		actionList.units2, actionList.units3]
	
	var i = buildMenuTab - 1
	var buildList = buildLists[i]
	var grid = selectUnitPanel.get_child(buildMenuTab)
	
	var isPackedScene = false
	if !buildList.is_empty():
		assert(buildList[0] is PackedScene || buildList[0] is Recipe, \
			'buildList should contain either a PackedScene or an Array[Inventory]')
		
		isPackedScene = (buildList[0] is PackedScene)
	
	var selectedBuildingScene = player.getBuildmenuBuilding()
	for j in range(12):
		var gridElementBuildingUI = grid.get_node("Building" + str(j) + "/BuildingUI")
		var gridElementCraftItemUI = grid.get_node("CraftItem" + str(j) + "/CraftItemUI")
		if j >= buildList.size():
			gridElementBuildingUI.hide()
			gridElementCraftItemUI.hide()
			if isPackedScene:
				gridElementBuildingUI.get_parent().show() 
				gridElementCraftItemUI.get_parent().hide() 
			else:
				gridElementBuildingUI.get_parent().hide() 
				gridElementCraftItemUI.get_parent().show() 
			continue
			
		gridElementBuildingUI.show()
		gridElementCraftItemUI.show()
		
		if isPackedScene:
			gridElementBuildingUI.get_parent().show() 
			gridElementCraftItemUI.get_parent().hide() 
			
			var buildingScene: PackedScene = buildList[j]
			var building: Unit = buildingScene.instantiate()
			grid.get_node("Building" + str(j) + "/Button").tooltip_text = building.getDisplayName()

			updateGridElementBuilding(unit, gridElementBuildingUI, building)
			if !selectedBuildingScene || (selectedBuildingScene && buildingScene == selectedBuildingScene):
				gridElementBuildingUI.modulate = Color(1.0, 1.0, 1.0, 1.0)
			else:
				gridElementBuildingUI.modulate = Color(0.8, 0.8, 0.8, 0.8)
				
		else:
			gridElementCraftItemUI.get_parent().show() 
			gridElementBuildingUI.get_parent().hide()
			
			updateGridElementCraftItem(unit, gridElementCraftItemUI,  buildList[j])
			
func updateGridElementBuilding(unit: Unit, gridElement: Control, building: Unit):
	var sprite2D = building.get_node("Sprite2D")
	var nodeTexture = gridElement.get_node("ClipContentNode/Texture")
	nodeTexture.texture = sprite2D.texture
	
	gridElement.get_node("Cost/Energy/Value").text = str(building.energyCost)
	
	if world.hasEnergy(building.energyCost):
		gridElement.get_node("Cost/Energy/Value").self_modulate = Color(1,1,1)
	else:
		gridElement.get_node("Cost/Energy/Value").self_modulate = Color(0.8,0.2,0.2)
	
	var nResources = building.resourceCost.resources.size()
	assert(nResources < 4, 'hud:updateResourceCost: cannot show more than three unique resources in the cost')
	var resourceNames = building.resourceCost.resources.keys()
	var resourceValues = building.resourceCost.resources.values()
	
	for i in range(3):
		var rName: String = ""
		var rValue: int = 0
		var hasResources = false
		if nResources > i:
			rName = resourceNames[i]
			rValue = resourceValues[i]
			hasResources = unit.inventory.hasResources(rName, rValue)
		
		var resourceNode = gridElement.get_node("Cost/Resource" + str(i))
		resourceNode.get_node("Value").text = str(rValue) if rValue > 0 else ""
		resourceNode.get_node("Texture").texture = Utils.getResourceTexture(rName) if rValue > 0 else null
		if hasResources:
			resourceNode.get_node("Value").self_modulate = Color(1,1,1)
		else:
			resourceNode.get_node("Value").self_modulate = Color(0.8,0.2,0.2)
		
func updateGridElementCraftItem(unit: Unit, gridElement: Control, recipe: Recipe):
	var nodeNames = ["Recipe", "Product"]
	var resources = [recipe.inputRecipe, recipe.product]
	
	if (!unit.recipe || recipe == unit.recipe):
		gridElement.modulate = Color(1, 1, 1, 1)
	else:
		gridElement.modulate = Color(0.8, 0.8, 0.8, 0.8)
		
	gridElement.get_node("../Button").tooltip_text = recipe.getDisplayName()
	for i in range(2):
		var resourceNames = resources[i].resources.keys()
		var resourceValues = resources[i].resources.values()
		
		for j in range(3):
			var rName: String = ""
			var rValue: int = 0
			var hasResources = false
			if resourceValues.size() > j:
				rName = resourceNames[j]
				rValue = resourceValues[j]
				hasResources = unit.inventory.hasResources(rName, rValue)
			
			var resourceNode = gridElement.get_node(nodeNames[i] + "/Resource" + str(j))
			resourceNode.get_node("Value").text = str(rValue) if rValue > 0 else ""
			resourceNode.get_node("Texture").texture = Utils.getResourceTexture(rName) if rValue > 0 else null
			if i == 0:
				if hasResources:
					resourceNode.get_node("Value").self_modulate = Color(1,1,1)
				else:
					resourceNode.get_node("Value").self_modulate = Color(0.8,0.2,0.2)

func isMouseOnHUD():
	var mousePos = get_viewport().get_mouse_position()
	
	var mainPanels = [selectUnitPanel, worldStatePanel, inputConfigPanel]
	
	for panel in mainPanels:
		var pos = panel.get_screen_position()
		var size = panel.size
		if mousePos.x > pos.x && mousePos.x < pos.x + size.x && \
			mousePos.y > pos.y && mousePos.y < pos.y + size.y:
			
			return true 
	
	return false

func onPressBuildmenuBuilding(index: int):
	player.setBuildmenuBuilding(index)

func onTabChanged(tabIndex: int):
	player.setBuildmenuState(tabIndex)
	updateSelectedUnitPanel()
	
func _unhandled_input(event):
	if event:
		updateEnergyPanel()
		updateSelectedUnitPanel()

