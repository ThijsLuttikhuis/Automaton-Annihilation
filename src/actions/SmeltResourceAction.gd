class_name SmeltResourceAction extends PlaceResourceAction

var preSmeltResourceName: String

var duration: float = 1.0
var time: float = 0.0

func _init(resourceName_, duration_):
	assert(Item.isSmeltable(resourceName_), 'Cannot Smelt a non-smeltable Item')
	duration = duration_
	resourceName = Item.getSmeltProduct(resourceName_)
	preSmeltResourceName = resourceName_
	
func update(unit: Unit, dt):
	if actionPosition == Vector2(9e9, 9e9):
		actionPosition = unit.position
		var success = unit.inventory.ifHasResourcesRemove(preSmeltResourceName, 1)
		if !success:
			return true # skip cause no resource available
		
	time += dt
	
	if time > duration:
		var placed = placeResource(unit, true, true) #check place on conveyor belts
		if !placed:
			placed = placeResource(unit, false) #check place on ground
		if placed: 
			return true
	else:
		var sprite = unit.get_node("Sprite2D")
		sprite.set_frame(ceil(time * 3.9))
	
	return false
