class_name ConvertResourceAction extends PlaceResourceAction

const setWaitTicks: int = 2

var recipeResources: Inventory
var product

var duration: float
var time: float = 0.0
var waitTicks: int = 0

func _init(recipeResources_: Inventory, product_, duration_):
	assert(product_ is Inventory || product_ is PackedScene, \
		'product should be an Inventory or a PackedScene')
		
	duration = duration_
	recipeResources = Inventory.deepCopy(recipeResources_)
	
	if product_ is Inventory:
		product = Inventory.deepCopy(product_)
	if product_ is PackedScene:
		product = product_

func update(unit: Unit, dt):
	if actionPosition == Vector2(9e9, 9e9):
		actionPosition = unit.position
		var success = unit.inventory.ifHasResourcesRemove(recipeResources, 1)
		if !success:
			return true # skip cause no resource available
		
	time += dt
	
	if time > duration:
		if product is Inventory:
			return placeResourceProduct(unit)
		else:
			return placeResourceUnit(unit)
	else:
		var sprite = unit.get_node("Sprite2D")
		sprite.set_frame(ceil(time / duration * (sprite.hframes-1.1)))
	
	return false

func placeResourceProduct(unit):
	if waitTicks > 0:
		waitTicks -= 1
		return false
		
	resourceName = product.getFirstItemName()
	if !resourceName:
		return true
		
	var placed = placeResource(unit, true, true) #check place on conveyor belts
	if !placed:
		placed = placeResource(unit, false) #check place on ground
	if placed: 
		product.removeTillEmpty(resourceName, 1)
		waitTicks = setWaitTicks
		return product.is_empty()

func placeResourceUnit(unit):
	# todo
	pass
