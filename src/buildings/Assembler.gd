class_name Assembler extends ConvertResourceBuilding

func _init():
	energyCost = 200
	resourceCost.add("Iron Plate", 9)
	
	multiRecipe = Inventory.new()
	multiProduct = Inventory.new()
	
	duration = 2.0

func _ready():
	initBuildActionList()
	initInputConfiguration()

func initBuildActionList():
	buildActionList = BuildActionList.new()
	buildActionList.tabNames = ["Basic", "Military"]
	
	var recipeIronGear = Inventory.new()
	recipeIronGear.add('Iron Plate', 2)
	var productIronGear = Inventory.new()
	productIronGear.add('Iron Gear', 2)
	buildActionList.units0.push_back([recipeIronGear, productIronGear])
	
	var recipeCopperWire = Inventory.new()
	recipeIronGear.add('Copper Plate', 2)
	var productCopperWire = Inventory.new()
	productIronGear.add('Copper Wire', 2)
	buildActionList.units0.push_back([recipeCopperWire, productCopperWire])
	
func initInputConfiguration():
	pass #todo

func getDisplayName():
	return "Assembler"
