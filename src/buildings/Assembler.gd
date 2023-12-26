class_name Assembler extends ConvertResourceBuilding

func _init():
	energyCost = 200
	resourceCost.add("Iron Plate", 9)
	
	recipe = Recipe.new()
	
	duration = 2.0

func on_ready():
	initBuildActionList()
	initInputConfiguration()

func initBuildActionList():
	buildActionList = BuildActionList.new()
	buildActionList.tabNames = ["Basic", "Military"]
	
	var recipeInputIronGear = Inventory.new()
	recipeInputIronGear.add('Iron Plate', 2)
	var productIronGear = Inventory.new()
	productIronGear.add('Iron Gear', 2)
	var recipeIronGear = Recipe.new(recipeInputIronGear, productIronGear)
	buildActionList.units0.push_back(recipeIronGear)
	
	var recipeInputCopperWire = Inventory.new()
	recipeInputCopperWire.add('Copper Plate', 2)
	var productCopperWire = Inventory.new()
	productCopperWire.add('Copper Wire', 2)
	var recipeCopperWire = Recipe.new(recipeInputCopperWire, productCopperWire)
	buildActionList.units0.push_back(recipeCopperWire)
	
func initInputConfiguration():
	pass #todo

func getDisplayName():
	return "Assembler"
