class_name Recipe

var inputRecipe: Inventory = Inventory.new()
var product

func _init(inputRecipe_: Inventory = null, product_ = null):
	if inputRecipe_:
		inputRecipe = inputRecipe_
	else:
		inputRecipe = Inventory.new()
	if product_:
		assert(product_ is PackedScene || product_ is Inventory)
		product = product_

static func deepCopy(recipe_: Recipe):
	var recipeCopy = Inventory.deepCopy(recipe_.inputRecipe)
	var productCopy
	if recipe_.product is Inventory:
		productCopy = Inventory.deepCopy(recipe_.product)
	if recipe_.product is PackedScene:
		productCopy = recipe_.product
	
	return Recipe.new(recipeCopy, productCopy)

