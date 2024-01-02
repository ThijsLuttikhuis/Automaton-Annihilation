class_name ConvertResourceAction extends UnitAction

const setWaitTicks: int = 2

var recipe: Recipe

var duration: float
var time: float = 0.0
var waitTicks: int = 0

func _init(recipe_: Recipe, duration_):
	assert(recipe_.product is Inventory || recipe_.product is PackedScene, \
		'product should be an Inventory or a PackedScene')
		
	duration = duration_
	
	recipe = Recipe.deepCopy(recipe_)
	

func update(unit: Unit, dt):
	if actionPosition == Vector2(9e9, 9e9):
		actionPosition = unit.position
		var success = unit.inventory.ifHasResourcesRemove(recipe.inputRecipe, 1)
		if !success:
			return true # skip cause no resource available
	
	time += dt
	if time > duration:
		if recipe.product is Inventory:
			return placeResourceProduct(unit, recipe.product)
		else:
			return placeUnitProduct(unit, recipe.product)
	else:
		var sprite = unit.get_node("Sprite2D")
		sprite.set_frame(ceil(time / duration * (sprite.hframes-1.1)))
	
	return false

func placeResourceProduct(unit: Unit, resourceProduct: Inventory):
	if waitTicks > 0:
		waitTicks -= 1
		return false
	
	var resourceName = resourceProduct.getFirstItemName()
	if !resourceName:
		return true
	
	var placed = unit.placeItemsComponent.placeResource(resourceName)
	if placed: 
		resourceProduct.remove(resourceName, 1)
		waitTicks = setWaitTicks
		return resourceProduct.is_empty()

func placeUnitProduct(unit: Unit, unitProductScene: PackedScene):
	var unitProduct = unitProductScene.instantiate()
	unitProduct.position = actionPosition
	unit.player.world.get_node("Units").add_child(unitProduct)
	return true
