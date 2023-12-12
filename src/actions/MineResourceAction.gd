class_name MineResourceAction extends PlaceResourceAction

var efficiency: int = 1
var time: float = 0.0
var resourceGain: float = 0.0

var resourceRichness: float

func _init(efficiency_):
	efficiency = efficiency_
	isPassive = true
	
func update(unit: Unit, dt):
	if actionPosition == Vector2(9e9, 9e9):
		actionPosition = unit.position
		var tileMap = unit.player.tileMap
		var cellI = tileMap.local_to_map(actionPosition)
		var tile = tileMap.get_cell_tile_data(1, cellI)
		resourceName = tile.get_custom_data("resourceName")
		resourceRichness = tile.get_custom_data("resourceRichness")
	
	time += dt
	resourceGain += resourceRichness * efficiency * dt
	
	if resourceGain > 1:
		var placed = placeResource(unit, true) #check place on conveyor belts
		if !placed:
			placed = placeResource(unit, false) #check place on ground
		if placed: 
			resourceGain = 0
	else:
		var animationSpriteI: int = floor(resourceGain * 10.0)
		var frame = animationSpriteI if animationSpriteI < 3 else \
			1 if animationSpriteI > 8 else \
			2 + animationSpriteI % 2
		
		var sprite = unit.get_node("Sprite2D")
		sprite.set_frame(frame)
		
